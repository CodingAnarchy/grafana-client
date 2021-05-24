# frozen_string_literal: true

require_relative 'client/base_client'
require_relative 'modules/dashboard'
require_relative 'modules/folder'
require_relative 'modules/data_source'

module Grafana
  class Client < BaseClient
    # Include all modules into main Client class
    client_modules = Grafana::Modules.constants.select { |c| Grafana::Modules.const_get(c).is_a?(Module) }
    client_modules.each do |module_const|
      include Grafana::Modules.const_get(module_const)
    end
  end
end
