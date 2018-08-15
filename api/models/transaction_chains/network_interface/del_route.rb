module TransactionChains
  class NetworkInterface::DelRoute < ::TransactionChain
    label 'Route-'

    # @param netif [::NetworkInterface]
    # @param ips [Array<::IpAddress>]
    # @param opts [Hash] options
    # @option opts [Boolean] :unregister
    # @option opts [Boolean] :reallocate
    def link_chain(netif, ips, opts = {})
      opts[:unregister] = true unless opts.has_key?(:unregister)
      opts[:reallocate] = true unless opts.has_key?(:reallocate)

      lock(netif.vps)
      concerns(:affect, [netif.vps.class.name, netif.vps.id])

      uses = []
      user_env = netif.vps.user.environment_user_configs.find_by!(
        environment: netif.vps.node.location.environment,
      )
      ips_arr = ips.to_a

      if opts[:reallocate] && !netif.vps.node.location.environment.user_ip_ownership
        %i(ipv4 ipv4_private ipv6).each do |r|
          cnt = case r
          when :ipv4
            ips_arr.inject(0) do |sum, ip|
              if ip.network.role == 'public_access' && ip.network.ip_version == 4
                sum + ip.size

              else
                sum
              end
            end

          when :ipv4_private
            ips_arr.inject(0) do |sum, ip|
              if ip.network.role == 'private_access' && ip.network.ip_version == 4
                sum + ip.size

              else
                sum
              end
            end

          when :ipv6
            ips_arr.inject(0) do |sum, ip|
              if ip.network.ip_version == 6
                sum + ip.size

              else
                sum
              end
            end
          end

          uses << user_env.reallocate_resource!(
            r,
            user_env.send(r) - cnt,
            user: netif.vps.user
          )
        end
      end

      ips_arr.each do |ip|
        lock(ip)

        append_t(
          Transactions::NetworkInterface::RouteDel,
          args: [netif, ip, opts[:unregister]]
        ) do |t|
          t.edit(ip, network_interface_id: nil, order: nil)
          t.just_create(
            netif.vps.log(:ip_del, {id: ip.id, addr: ip.addr})
          ) unless included?
        end
      end

      append_t(Transactions::Utils::NoOp, args: netif.vps.node_id) do |t|
        uses.each do |use|
          t.edit(use, value: use.value)
        end
      end unless uses.empty?
    end
  end
end
