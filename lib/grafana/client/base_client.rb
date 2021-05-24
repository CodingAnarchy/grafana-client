# frozen_string_literal: true

require 'faraday'

require_relative 'version'

module Grafana
  class BaseClient
    def initialize(grafana_url: Grafana.grafana_url, api_key: Grafana.api_key)
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
