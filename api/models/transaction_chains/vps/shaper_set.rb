module TransactionChains
  class Vps::ShaperSet < ::TransactionChain
    label 'Shaper+'

    def link_chain(vps, ips = nil)
      concerns(:affect, [vps.class.name, vps.id])

      (ips || vps.ip_addresses.all).each do |ip|
        lock(ip)

        append(Transactions::Shaper::Set, args: [ip, vps])
      end
    end
  end
end
