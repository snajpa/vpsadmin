module TransactionChains
  class Vps::ShaperChange < ::TransactionChain
    label 'Shaper*'

    def link_chain(ip, tx, rx)
      lock(ip.vps)
      lock(ip)
      concerns(:affect, [ip.vps.class.name, ip.vps.id])

      append(Transactions::Vps::ShaperChange, args: [ip, tx, rx]) do
        edit(ip, max_tx: tx, max_rx: rx)
      end
    end
  end
end
