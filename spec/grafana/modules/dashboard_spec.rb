require 'spec_helper'

RSpec.describe Grafana::Modules::Dashboard do
  class TestDashboardClient < Grafana::BaseClient
    include Grafana::Modules::Dashboard
  end

  subject(:test_client) { TestDashboardClient.new }

  describe "#home_dashboard" do
    it "calls the home dashboard api" do
      stub = stub_request(:get, "https://test.grafana.io/api/dashboards/home")

      subject.home_dashboard

      expect(stub).to have_been_requested
    end
  end
end
