class VpsAdmin::API::Resources::VPS < HaveAPI::Resource
  version 1
  model ::Vps
  desc 'Manage VPS'

  params(:id) do
    id :id, label: 'VPS id', db_name: :vps_id
  end

  params(:template) do
    resource VpsAdmin::API::Resources::OsTemplate, label: 'OS template',
             value_params: ->{ @vps.vps_template }
  end

  params(:common) do
    resource VpsAdmin::API::Resources::User, label: 'User', desc: 'VPS owner',
             value_label: :login, value_params: ->{ @vps.m_id }
    string :hostname, desc: 'VPS hostname', db_name: :vps_hostname,
           required: true
    use :template
    string :info, label: 'Info', desc: 'VPS description', db_name: :vps_info
    resource VpsAdmin::API::Resources::DnsResolver, label: 'DNS resolver',
             desc: 'DNS resolver the VPS will use',
             value_params: ->{ @vps.dns_resolver_id }
    resource VpsAdmin::API::Resources::Node, label: 'Node', desc: 'Node VPS will run on',
             value_label: :name, value_params: ->{ @vps.vps_server }
    bool :onboot, label: 'On boot', desc: 'Start VPS on node boot?',
         db_name: :vps_onboot, default: true
    bool :onstartall, label: 'On start all',
         desc: 'Start VPS on start all action?', db_name: :vps_onstartall,
         default: true
    bool :backup_enabled, label: 'Enable backups', desc: 'Toggle VPS backups',
         db_name: :vps_backup_enabled, default: true
    string :config, label: 'Config', desc: 'Custom configuration options',
           db_name: :vps_config, default: ''
  end

  class Index < HaveAPI::Actions::Default::Index
    desc 'List VPS'

    output(:list) do
      use :id
      use :common
    end

    authorize do |u|
      allow if u.role == :admin
      restrict m_id: u.m_id
      output whitelist: %i(id hostname os_template dns_resolver node backup_enabled)
      allow
    end

    example do
      request({})
      response({vpses: [
        {
            id: 150,
            user: {
                id: 1,
                name: 'somebody'
            },
            hostname: 'thehostname',
            os_template: {
                id: 1,
                label: 'Scientific Linux 6'
            },
            info: 'My very important VPS',
            dns_resolver: {
                id: 1,
            },
            node: {
                id: 1,
                name: 'node1'
            },
            onboot: true,
            onstartall: true,
            backup_enabled: true,
            config: '',
        }
      ]})
    end

    def exec
      ret = []

      Vps.where(with_restricted).each do |vps|
        ret << to_param_names(all_attrs(vps), :output)
      end

      ret
    end
  end

  class Create < HaveAPI::Actions::Default::Create
    desc 'Create VPS'

    input do
      use :common
    end

    output do
      integer :vps_id, label: 'VPS id', desc: 'ID of created VPS'
    end

    authorize do |u|
      allow if u.role == :admin
      input whitelist: %i(hostname os_template dns_resolver)
      allow
    end

    example do
      request({
        vps: {
          user: 1,
          hostname: 'my-vps',
          os_template: 1,
          info: '',
          dns_resolver: 1,
          node: 1,
          onboot: true,
          onstartall: true,
          backup_enabled: true,
          config: ''
        }
      })
      response({
        vps: {
            vps_id: 150
        }
      })
      comment <<END
Create VPS owned by user with ID 1, template ID 1 and DNS resolver ID 1. VPS
will be created on node ID 1. Action returns ID of newly created VPS.
END
    end

    def exec
      vps_params = params[:vps]

      unless current_user.role == :admin
        unless current_user.can_use_playground?
          error('playground disabled or VPS already exists')
        end

        vps_params.update({
            user: current_user,
            node: ::Node.pick_node_by_location_type('playground'),
            vps_expiration: Time.new.to_i +
                            SysConfig.get('playground_vps_lifetime')* 24 * 60 * 60
        })
      end

      vps = ::Vps.new(to_db_names(vps_params))

      if vps.create
        unless current_user.role == :admin
          vps.add_ip(::IpAddress.pick_addr!(vps.node.location, 4))

          if vps.node.location.has_ipv6
            vps.add_ip(::IpAddress.pick_addr!(vps.node.location, 6))
          end
        end

        ok({vps_id: vps.id})

      else
        error('save failed', to_param_names(vps.errors.to_hash, :input))
      end
    end
  end

  class Show < HaveAPI::Actions::Default::Show
    desc 'Show VPS properties'

    output do
      use :id
      use :common
    end

    # example do
    #   request({})
    #   response({})
    #   comment ''
    # end

    authorize do |u|
      allow if u.role == :admin
      restrict m_id: u.m_id
      output whitelist: %i(id hostname os_template dns_resolver node backup_enabled)
      allow
    end

    def prepare
      @vps = Vps.find_by!(with_restricted(vps_id: params[:vps_id]))
    end

    def exec
      to_param_names(all_attrs(@vps), :output)
    end
  end

  class Update < HaveAPI::Actions::Default::Update
    desc 'Update VPS'

    input do
      use :common
    end

    authorize do |u|
      allow if u.role == :admin
      restrict m_id: u.m_id
      input whitelist: %i(hostname os_template dns_resolver)
      allow
    end

    def exec
      vps = ::Vps.find_by!(with_restricted(vps_id: params[:vps_id]))

      if vps.update(to_db_names(params[:vps]))
        ok
      else
        error('update failed', to_param_names(vps.errors.to_hash, :input))
      end
    end
  end

  class Delete < HaveAPI::Actions::Default::Delete
    desc 'Delete VPS'

    input do
      bool :lazy, label: 'Lazy delete', desc: 'Only mark VPS as deleted',
           default: true
    end

    authorize do |u|
      allow if u.role == :admin
      restrict m_id: u.m_id
      input whitelist: []
      allow
    end

    def exec
      ::Vps.find_by!(with_restricted(vps_id: params[:vps_id])).lazy_delete(
          current_user.role == :admin ? params[:vps][:lazy] : true
      )
      ok
    end
  end

  class Start < HaveAPI::Action
    desc 'Start VPS'
    route ':%{resource}_id/start'
    http_method :post

    authorize do |u|
      allow if u.role == :admin
      restrict m_id: u.m_id
      allow
    end

    def exec
      ::Vps.find_by!(with_restricted(vps_id: params[:vps_id])).start
      ok
    end
  end

  class Restart < HaveAPI::Action
    desc 'Restart VPS'
    route ':%{resource}_id/restart'
    http_method :post

    authorize do |u|
      allow if u.role == :admin
      restrict m_id: u.m_id
      allow
    end

    def exec
      ::Vps.find_by!(with_restricted(vps_id: params[:vps_id])).restart
      ok
    end
  end

  class Stop < HaveAPI::Action
    desc 'Stop VPS'
    route ':%{resource}_id/stop'
    http_method :post

    authorize do |u|
      allow if u.role == :admin
      restrict m_id: u.m_id
      allow
    end

    def exec
      ::Vps.find_by!(with_restricted(vps_id: params[:vps_id])).stop
      ok
    end
  end

  class Passwd < HaveAPI::Action
    desc 'Set root password'
    route ':%{resource}_id/passwd'
    http_method :post

    output do
      string :password, label: 'Password', desc: 'Auto-generated password'
    end

    authorize do |u|
      allow if u.role == :admin
      restrict m_id: u.m_id
      allow
    end

    def exec
      {password: ::Vps.find_by!(with_restricted(vps_id: params[:vps_id])).passwd}
    end
  end

  class Reinstall < HaveAPI::Action
    desc 'Reinstall VPS'
    route ':%{resource}_id/reinstall'
    http_method :post

    input do
      use :template
    end

    authorize do |u|
      allow if u.role == :admin
      restrict m_id: u.m_id
      allow
    end

    def exec
      vps = ::Vps.find_by!(with_restricted(vps_id: params[:vps_id]))
      tpl = params[:vps][:os_template]

      error('selected os template is disabled') unless tpl.enabled?

      if vps.update(os_template: tpl)
        vps.reinstall
        ok
      else
        error('reinstall failed', to_param_names(vps.errors.to_hash, :input))
      end
    end
  end

  class Config < HaveAPI::Resource
    version 1
    route ':vps_id/configs'
    desc 'Manage VPS configs'

    class Index < HaveAPI::Actions::Default::Index
      desc 'List VPS configs'

      output(:list) do
        integer :config_id, label: 'Config ID'
        string :name, label: 'Config name', desc: 'Used internally'
        string :label, label: 'Config label', desc: 'Nice name for user'
      end

      authorize do |u|
        allow if u.role == :admin
        restrict m_id: u.m_id
        allow
      end

      def exec
        ret = []

        ::Vps.find_by!(with_restricted(vps_id: params[:vps_id])).vps_configs.all.each do |c|
          ret << {
              config_id: c.id,
              name: c.name,
              label: c.label
          }
        end

        ret
      end
    end

    class Update < HaveAPI::Actions::Default::Update
      desc 'Update VPS configs'

      input do
        integer :config_id, label: 'Config ID', db_name: :id
      end

      authorize do |u|
        allow if u.role == :admin
      end

      def exec
        configs = ::VpsConfig.find(to_db_names(params[:configs]))
      end
    end
  end

  class IpAddress < HaveAPI::Resource
    version 1
    model ::IpAddress
    route ':vps_id/ip_addresses'
    desc 'Manage VPS IP addresses'

    params(:common) do
      id :id, label: 'IP address ID', db_name: :ip_id
      string :addr, label: 'Address', desc: 'Address itself', db_name: :ip_addr
      integer :version, label: 'IP version', desc: '4 or 6', db_name: :ip_v
    end

    class Index < HaveAPI::Actions::Default::Index
      desc 'List VPS IP addresses'

      input(namespace: :ip_addresses) do
        integer :version, label: 'IP version', desc: '4 or 6', db_name: :ip_v
      end

      output(:list) do
        use :common
      end

      authorize do |u|
        allow if u.role == :admin
        restrict m_id: u.m_id
        allow
      end

      def exec
        ret = []

        ::Vps.find_by!(with_restricted(vps_id: params[:vps_id])).ip_addresses.where(to_db_names(params[:ip_addresses])).each do |ip|
          ret << {
              id: ip.ip_id,
              addr: ip.ip_addr,
              version: ip.ip_v,
          }
        end

        ret
      end
    end

    class Create < HaveAPI::Actions::Default::Create
      desc 'Assign IP address to VPS'

      input do
        id :id, label: 'IP address ID',
           desc: 'If ID is 0, first free IP address of given version is assigned',
           db_name: :ip_id
        integer :version, label: 'IP version',
                desc: '4 or 6, provide only if id is 0', db_name: :ip_v,
                required: true
      end

      output do
        use :common
      end

      authorize do |u|
        allow if u.role == :admin
      end

      def exec
        vps = ::Vps.find(params[:vps_id])

        if !params[:ip_address][:id] || params[:ip_address][:id] == 0
          ip = ::IpAddress.pick_addr!(vps.node.location, params[:ip_address][:version])
        else
          ip = ::IpAddress.find_by!(ip_id: params[:ip_address][:id], location: vps.node.location)
        end

        if ip.free?
          vps.add_ip(ip)
          ok
        else
          error('IP address is already in use')
        end
      end
    end

    class Delete < HaveAPI::Actions::Default::Delete
      desc 'Free IP address'

      authorize do |u|
        allow if u.role == :admin
      end

      def exec
        vps = ::Vps.find(params[:vps_id])
        vps.delete_ip(vps.ip_addresses.find(params[:ip_address_id]))
      end
    end

    class DeleteAll < HaveAPI::Action
      desc 'Free all IP addresses'
      route ''
      http_method :delete

      input(namespace: :ip_addresses) do
        integer :version, label: 'IP version',
                desc: '4 or 6, delete addresses of selected version', db_name: :ip_v
      end

      authorize do |u|
        allow if u.role == :admin
      end

      def exec
        ::Vps.find(params[:vps_id]).delete_ips((params[:ip_addresses] || {})[:version])
      end
    end
  end
end
