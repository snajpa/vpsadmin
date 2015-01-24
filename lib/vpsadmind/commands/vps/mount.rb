module VpsAdmind
  class Commands::Vps::Mount < Commands::Base
    handle 5302
    needs :system, :vz, :vps, :zfs, :pool

    def exec
      return ok unless status[:running]

      @mounts.each do |mnt|
        case mnt['type']
          when 'snapshot_local'
            dst = "#{ve_root}/#{mnt['dst']}"

            syscmd("#{$CFG.get(:bin, :mount)} -t zfs #{mnt['pool_fs']}/#{mnt['dataset_name']}@#{mnt['snapshot']} #{dst}")

          when 'snapshot_remote'

          else
            dst = "#{ve_root}/#{mnt['dst']}"

            unless File.exists?(dst)
              begin
                FileUtils.mkpath(dst)

              # it means, that the folder is mounted but was removed on the other end
              rescue Errno::EEXIST
                syscmd("#{$CFG.get(:bin, :umount)} -f #{dst}")
              end
            end

            runscript('premount', mnt['premount']) if mnt['runscripts']
            syscmd("#{$CFG.get(:bin, :mount)} #{mnt['mount_opts']} -o #{mnt['mode']} #{mnt['src']} #{dst}")
            runscript('postmount', mnt['postmount']) if mnt['runscripts']
        end
      end

      ok
    end

    def rollback
      call_cmd(Commands::Vps::Umount, {
          :mounts => @mounts.reverse,
          :runscripts => false
      })
    end
  end
end
