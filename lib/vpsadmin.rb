require 'require_all'
require 'active_record'
require 'composite_primary_keys'
require 'paper_trail'
require 'pp'
require 'haveapi'
require 'ancestry'
require 'ipaddress'

Thread.abort_on_exception = true

module VpsAdmin
  module API
    module Resources

    end

    module Actions

    end
  end
end

require_relative 'vpsadmin/scheduler'
require_relative 'vpsadmin/api/crypto_providers'
require_relative 'vpsadmin/api/maintainable'
require_relative 'vpsadmin/api/dataset_properties'
require_rel 'vpsadmin/*.rb'
require_rel 'vpsadmin/api/*.rb'
require_rel 'vpsadmin/api/authentication'

VpsAdmin::API.load_configurable(:dataset_properties)

require_rel '../models'

VpsAdmin::API.load_configurable(:hooks)
VpsAdmin::API.load_configurable(:dataset_plans)

require_rel 'vpsadmin/api/resources'
