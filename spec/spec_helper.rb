# frozen_string_literal: true

require 'webmock/rspec'
require "grafana/client"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

# Configure dummy values for client to be used in test expectations
Grafana::Client.config do |c|
  c.api_key = "dummy"
  c.grafana_url = "https://test.grafana.io"
end
