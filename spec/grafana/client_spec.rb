# frozen_string_literal: true

RSpec.describe Grafana::Client do
  it 'has a version number' do
    expect(Grafana::Client::VERSION).not_to be nil
  end
end
