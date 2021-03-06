class VpsAdmin::API::Resources::VpsConfig < HaveAPI::Resource
  model ::VpsConfig
  desc 'Manage VPS configs'

  params(:id) do
    id :id, label: 'Config ID'
  end

  params(:common) do
    string :name, label: 'Config name', desc: 'Used internally'
    string :label, label: 'Config label', desc: 'Nice name for user'
    string :config, label: 'Config', desc: 'Configuration directives'
  end

  params(:all) do
    use :id
    use :common
  end

  class Index < HaveAPI::Actions::Default::Index
    desc 'List VPS configs'

    output(:object_list) do
      use :all
    end

    authorize do |u|
      allow if u.role == :admin
    end

    def query
      ::VpsConfig.all
    end

    def count
      query.count
    end

    def exec
      query.limit(params[:vps_config][:limit]).offset(params[:vps_config][:offset])
    end
  end

  class Create < HaveAPI::Actions::Default::Create
    desc 'Create a new VPS config'
    blocking true

    input do
      use :common
    end

    output do
      use :all
    end

    authorize do |u|
      allow if u.role == :admin
    end

    def exec
      cfg = ::VpsConfig.new(input)
      @chain, ret = cfg.create!
      ret

    rescue ActiveRecord::RecordInvalid
      error('save failed', cfg.errors.to_hash)
    end

    def state_id
      @chain.id
    end
  end

  class Show < HaveAPI::Actions::Default::Show
    desc 'Show VPS config'

    output do
      use :all
    end

    authorize do |u|
      allow if u.role == :admin
      restrict whitelist: %i(label)
      allow
    end

    def exec
      ::VpsConfig.find(params[:vps_config_id])
    end
  end

  class Update < HaveAPI::Actions::Default::Update
    desc 'Update VPS config'
    blocking true

    input do
      use :common
    end

    authorize do |u|
      allow if u.role == :admin
    end

    def exec
      cfg = ::VpsConfig.find(params[:vps_config_id])
      @chain, _ = cfg.update!(input)

    rescue ActiveRecord::RecordInvalid
      error('update failed', cfg.errors.to_hash)
    end

    def state_id
      @chain.id
    end
  end

  # class Delete < HaveAPI::Actions::Default::Delete
  #   desc 'Delete VPS config'
  #
  #   authorize do |u|
  #     allow if u.role == :admin
  #   end
  #
  #   def exec
  #     ::VpsConfig.find(params[:vps_config_id]).destroy
  #   end
  # end
end
