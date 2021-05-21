# frozen_string_literal: true

require 'faraday'

require_relative 'client/version'
require_relative 'modules/dashboard'

module Grafana
  class Client
    # Include all modules into main Client class
    client_modules = Grafana::Modules.constants.select { |c| Grafana::Modules.const_get(c).is_a?(Module) }
    client_modules.each do |module_const|
      include Grafana::Modules.const_get(module_const)
    end

    def initialize(grafana_url:, api_key:)
      retry_options = {
        max: 2,
        retry_statuses: [429]
      }

      @conn = Faraday.new(url: grafana_url) do |f|
        f.token_auth(api_key)
        f.request :json # encode req bodies as JSON
        f.request :retry, retry_options # retry transient failures
        f.response :follow_redirects # follow redirects
        f.response :json # decode response bodies as JSON
      end
    end
  end
end
