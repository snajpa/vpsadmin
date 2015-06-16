require 'erb'
require 'tempfile'
require 'fileutils'

module VpsAdmind
  class Vps
    include Utils::Log
    include Utils::System
    include Utils::Vz
    include Utils::Zfs

    def initialize(veid)
      @veid = veid
    end

    def start
      try_harder do
        vzctl(:start, @veid, {}, false, [32,])
        vzctl(:set, @veid, {:onboot => "yes"}, true)
      end
    end

    def stop(params = {})
      try_harder do
        vzctl(:stop, @veid, {}, false, params[:force] ? [5, 66] : [])
        vzctl(:set, @veid, {:onboot => "no"}, true)
      end
    end

    def restart
      vzctl(:restart, @veid)
      vzctl(:set, @veid, {:onboot => "yes"}, true)
    end

    def suspend
      acquire_lock do
        unless File.exists?("#{ve_private}/sbin/iptables-save")
          File.symlink("/bin/true", "#{ve_private}/sbin/iptables-save")
          del = true
        end

        vzctl(:suspend, @veid, {:dumpfile => dumpfile})

        File.delete("#{ve_private}/sbin/iptables-save") if del
      end
    end

    def resume
      acquire_lock do
        unless File.exists?("#{ve_private}/sbin/iptables-restore")
          File.symlink("/bin/true", "#{ve_private}/sbin/iptables-restore")
          del = true
        end

        vzctl(:resume, @veid, {:dumpfile => dumpfile})

        File.delete("#{ve_private}/sbin/iptables-restore") if del
      end
    end

    def set_params(params)
      vzctl(:set, @veid, params, true)
    end

    def ip_add(addr, v, shaper)
      Shaper.new.shape_set(addr, v, shaper)
      Firewall.new.reg_ip(addr, v)

      vzctl(:set, @veid, {:ipadd => addr}, true)
    end

    def ip_del(addr, v, shaper)
      Shaper.new.shape_unset(addr, v, shaper)
      Firewall.new.unreg_ip(addr, v)

      vzctl(:set, @veid, {:ipdel => addr}, true)
    end

    def passwd(user, password)
      vzctl(:set, @veid, {:userpasswd => "#{user}:#{password}"})
    end

    def features
      acquire_lock do
        honor_state do
          stop
          vzctl(:set, @veid, {
              :feature => ["nfsd:on", "nfs:on", "ppp:on"],
              :capability => "net_admin:on",
              :netfilter => "full",
              :numiptent => "1000",
              :devices => ["c:10:200:rw", "c:10:229:rw", "c:108:0:rw"],
          }, true)
          start
          sleep(3)
          vzctl(:exec, @veid, "mkdir -p /dev/net")
          vzctl(:exec, @veid, "mknod /dev/net/tun c 10 200", false, [8,])
          vzctl(:exec, @veid, "chmod 600 /dev/net/tun")
          vzctl(:exec, @veid, "mknod /dev/fuse c 10 229", false, [8,])
          vzctl(:exec, @veid, "mknod /dev/ppp c 108 0", false, [8,])
          vzctl(:exec, @veid, "chmod 600 /dev/ppp")
        end
      end
    end

    def migrate_offline
      stop if @params["stop"]
      syscmd("#{$CFG.get(:vz, :vzmigrate)} #{@params["target"]} #{@veid}")
    end

    def migrate_online
      begin
        syscmd("#{$CFG.get(:vz, :vzmigrate)} --online #{@params["target"]} #{@veid}")
      rescue CommandFailed => err
        @output[:migration_cmd] = err.cmd
        @output[:migration_exitstatus] = err.rc
        @output[:migration_error] = err.output
        {:ret => :warning, :output => migrate_offline[:output]}
      end
    end

    def clone
      create
      syscmd("#{$CFG.get(:bin, :rm)} -rf #{$CFG.get(:vz, :vz_root)}/private/#{@veid}")

      if @params["is_local"]
        syscmd("#{$CFG.get(:bin, :cp)} -a #{$CFG.get(:vz, :vz_root)}/private/#{@params["src_veid"]}/ #{$CFG.get(:vz, :vz_root)}/private/#{@veid}")
      else
        rsync = $CFG.get(:vps, :clone, :rsync) \
          .gsub(/%\{rsync\}/, $CFG.get(:bin, :rsync)) \
          .gsub(/%\{src\}/, "#{@params["src_server_ip"]}:#{$CFG.get(:vz, :vz_root)}/private/#{@params["src_veid"]}/") \
          .gsub(/%\{dst\}/, "#{$CFG.get(:vz, :vz_root)}/private/#{@veid}")

        syscmd(rsync, [23, 24])
      end
    end

    def nas_umount(valid_rcs = [])
      runscript("preumount")
      syscmd("#{$CFG.get(:bin, :umount)} #{@params["umount_opts"]} #{ve_root}/#{@params["dst"]}", valid_rcs)
      runscript("postumount")
    end

    def nas_remount
      nas_umount([1])
      nas_mount
    end

    def load_file(file)
      vzctl(:exec, @veid, "cat #{file}")
    end

    def update_status(db)
      up = 0
      nproc = 0
      mem = 0
      disk = 0

      begin
        IO.popen("#{$CFG.get(:vz, :vzlist)} --no-header #{@veid}") do |io|
          status = io.read.split(" ")
          up = status[2] == "running" ? 1 : 0
          nproc = status[1].to_i

          mem_str = load_file("/proc/meminfo")[:output]
          mem = (mem_str.match(/^MemTotal\:\s+(\d+) kB$/)[1].to_i - mem_str.match(/^MemFree\:\s+(\d+) kB$/)[1].to_i) / 1024

          disk_str = vzctl(:exec, @veid, "#{$CFG.get(:bin, :df)} -k /")[:output]
          disk = disk_str.split("\n")[1].split(" ")[2].to_i / 1024
        end
      rescue

      end

      db.prepared(
          "INSERT INTO vps_status (vps_id, timestamp, vps_up, vps_nproc,
        vps_vm_used_mb, vps_disk_used_mb, vps_admin_ver) VALUES
        (?, ?, ?, ?, ?, ?, ?) ON DUPLICATE KEY UPDATE
        timestamp = ?, vps_up = ?, vps_nproc = ?, vps_vm_used_mb = ?,
        vps_disk_used_mb = ?, vps_admin_ver = ?",
          @veid.to_i, Time.now.to_i, up, nproc, mem, disk, VpsAdmind::VERSION,
          Time.now.to_i, up, nproc, mem, disk, VpsAdmind::VERSION
      )
    end

    def script_mount
      "#{$CFG.get(:vz, :vz_conf)}/conf/#{@veid}.mount"
    end

    def script_umount
      "#{$CFG.get(:vz, :vz_conf)}/conf/#{@veid}.umount"
    end

    def ve_conf
      "#{$CFG.get(:vz, :vz_conf)}/conf/#{@veid}.conf"
    end

    def ve_private
      $CFG.get(:vz, :ve_private).gsub(/%\{veid\}/, @veid.to_s)
    end

    def ve_root
      "#{$CFG.get(:vz, :vz_root)}/root/#{@veid}"
    end

    def dumpfile
      $CFG.get(:vps, :migration, :dumpfile).gsub(/%\{veid\}/, @veid.to_s)
    end

    def status
      stat = vzctl(:status, @veid)[:output].split(" ")[2..-1]
      {:exists => stat[0] == "exist", :mounted => stat[1] == "mounted", :running => stat[2] == "running"}
    end

    def honor_state
      before = status
      yield
      after = status

      if before[:running] && !after[:running]
        start
      elsif !before[:running] && after[:running]
        stop
      end
    end

    def ve_private_ds
      "#{$CFG.get(:vps, :zfs, :root_dataset)}/#{@veid}"
    end
  end
end
