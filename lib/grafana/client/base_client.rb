# frozen_string_literal: true

require 'faraday'
require 'faraday_middleware'

require_relative 'version'

module Grafana
  class BaseClient
    def initialize(grafana_url: Grafana::Client.grafana_url, api_key: Grafana::Client.api_key)
      retry_options = {
        max: 2,
        retry_statuses: [429]
      }

      @conn = Faraday.new(url: grafana_url) do |f|
        f.request :authorization, :Bearer, api_key
        f.request :json # encode req bodies as JSON
        f.request :retry, retry_options # retry transient failures
        f.response :follow_redirects # follow redirects
        f.response :json, content_type: /\bjson$/ # decode response bodies as JSON
      end
    end

    def get(url, **options)
      # TODO: error handling
      @conn.get(url, **options).body
    end

    def post(url, body, **options)
      response = @conn.post(url, body, **options)

      # TODO: handle errors in the response
      response.body
    end

    def delete(url, **options)
      response = @conn.delete(url, **options)

      response.body
    end
  end
end
