# frozen_string_literal: true

require_relative 'client/base_client'
Dir[File.join(__dir__, 'modules', '*.rb')].sort.each { |file| require file }

module Grafana
  class Client < Grafana::BaseClient
    class << self
      attr_accessor :api_key, :grafana_url

      def config
        yield self
      end
    end

    # Include all modules into main Client class
    client_modules = Grafana::Modules.constants.select { |c| Grafana::Modules.const_get(c).is_a?(Module) }
    client_modules.each do |module_const|
      include Grafana::Modules.const_get(module_const)
    end
  end
end
