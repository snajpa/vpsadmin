module TransactionChains
  class NetworkInterface::VethRouted::Create < NetworkInterface::Veth::Base
    label 'Veth+'

    # @param vps [::Vps]
    # @param name [String]
    def link_chain(vps, name)
      netif = create_netif(vps, 'veth_routed', name)

      # Assign interconneting networks for routed veth
      interconnecting_ips = Hash[ [4, 6].map { |v| [v, get_ip(vps, v)] } ]

      # Create the veth interface
      append_t(
        Transactions::NetworkInterface::CreateVethRouted,
        args: [netif, interconnecting_ips]
      ) do |t|
        t.just_create(netif)

        interconnecting_ips.each_value do |ip|
          t.edit_before(
            ip,
            network_interface_id: ip.network_interface_id,
            order: ip.order
          )

          ip.update!(
            network_interface_id: netif.id,
            order: 0, # interconnecting IPs are always first
          )
        end
      end

      netif
    end
  end
end
