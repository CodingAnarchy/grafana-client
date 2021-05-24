# frozen_string_literal: true

module Grafana
  class << self
    attr_accessor :api_key, :grafana_url

    def config
      yield self
    end
  end
end
