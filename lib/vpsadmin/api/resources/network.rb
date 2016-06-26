module VpsAdmin::API::Resources
  class Network < HaveAPI::Resource
    desc 'Manage networks'
    model ::Network

    params(:common) do
      string :label
      resource Location
      integer :ip_version
      string :address
      integer :prefix
      string :role
      bool :partial
      bool :managed
    end

    params(:all) do
      id :id
      use :common
    end

    class Index < HaveAPI::Actions::Default::Index
      desc 'List networks'

      output(:object_list) do
        use :all
      end

      authorize do |u|
        allow if u.role == :admin
        output whitelist: %i(location ip_version)
        allow
      end

      def query
        ::Network.all
      end

      def count
        query.count
      end

      def exec
        with_includes(query).offset(input[:offset]).limit(input[:limit])
      end
    end

    class Show < HaveAPI::Actions::Default::Show
      desc 'Show a network'

      output do
        use :all
      end

      authorize do |u|
        allow if u.role == :admin
        output whitelist: %i(location ip_version)
        allow
      end

      def prepare
        @net = ::Network.find(params[:network_id])
      end

      def exec
        @net
      end
    end
  end
end
