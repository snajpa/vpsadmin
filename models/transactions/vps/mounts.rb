module Transactions::Vps
  class Mounts < ::Transaction
    t_name :vps_mounts
    t_type 5301

    def params(vps, mounts)
      self.t_vps = vps.vps_id
      self.t_server = vps.vps_server

      res = []

      mounts.each do |mnt|
        if mnt.is_a?(::Mount)
          # FIXME

        elsif mnt.is_a?(::Hash)
          res << mnt

        else
          fail 'invalid mount type'
        end
      end

      {
          mounts: res
      }
    end
  end
end
