class IpRange < Network
  after_save :ensure_ip_addresses

  # @param net [::Network]
  # @param opts [Hash]
  # @option opts [::User] user
  def self.from_network(net, opts)
    net.get_or_create_range(opts)
  end

  def network
    parent
  end

  def size
    super + 2
  end

  protected
  def ensure_ip_addresses
    net_addr do |net|
      net.each do |ip|
        ::IpAddress.register(
            ip.address,
            network: self,
            user: self.user,
        )
      end
    end
  end
end
