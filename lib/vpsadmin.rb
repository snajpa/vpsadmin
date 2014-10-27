require 'require_all'
require 'active_record'
require 'composite_primary_keys'
require 'paper_trail'
require 'pp'
require 'haveapi'

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
require_relative 'vpsadmin/api/crypto_provider'
require_relative 'vpsadmin/api/hooks'
require_rel '../models'
require_relative 'vpsadmin/api'
