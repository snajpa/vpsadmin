module Transactions::Vps
  class IpAdd < ::Transaction
    t_name :vps_ip_add
    t_type 2006
    queue :network

    def params(vps, ip, register = true)
      self.vps_id = vps.id
      self.node_id = vps.node_id

      ret = {
        veth_name: vps.veth_name,
        addr: ip.addr,
        prefix: ip.prefix,
        version: ip.version,
        register: register,
        id: ip.id,
        user_id: ip.user_id || vps.user_id,
      }

      if register
        ret[:shaper] = {
          class_id: ip.class_id,
          max_tx: ip.max_tx,
          max_rx: ip.max_rx,
        }
      end

      ret
    end
  end
end
