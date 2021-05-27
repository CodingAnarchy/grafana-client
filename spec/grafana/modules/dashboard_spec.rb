require 'spec_helper'

RSpec.describe Grafana::Modules::Dashboard do
  class TestDashboardClient < Grafana::BaseClient
    include Grafana::Modules::Dashboard
  end

  subject(:test_client) { TestDashboardClient.new }
  let(:example_dashboard) do
    {
      "dashboard": {
        "editable":false,
        "hideControls":true,
        "nav":[
          {
            "enable":false,
            "type":"timepicker"
          }
        ],
        "style":"dark",
        "tags":[],
        "templating":{
          "list":[
          ]
        },
        "time":{
        },
        "timezone":"browser",
        "title":"Home",
        "version":5
      },
      "meta":	{
        "isHome":true,
        "canSave":false,
        "canEdit":false,
        "canStar":false,
        "url":"",
        "expires":"0001-01-01T00:00:00Z",
        "created":"0001-01-01T00:00:00Z"
      }
    }
  end

  describe "#home_dashboard" do
    it "calls the home dashboard api" do
      stub = stub_request(:get, "https://test.grafana.io/api/dashboards/home")
        .to_return(body: example_dashboard.to_json)

      dashboard = subject.home_dashboard

      expect(stub).to have_been_requested
      expect(dashboard).to eq(example_dashboard.deep_stringify_keys)
    end
  end

  describe "#dashboard" do
    it "requires the uid parameter" do
      expect {
        subject.dashboard
      }.to raise_error(ArgumentError)
    end

    it "returns a dashboard from the specified uid" do
      stub = stub_request(:get, "https://test.grafana.io/api/dashboards/uid/testuid")
        .and_return(body: example_dashboard.to_json)

      dashboard = subject.dashboard(uid: 'testuid')

      expect(stub).to have_been_requested
      expect(dashboard).to eq(example_dashboard.deep_stringify_keys)
    end
  end

  describe "#delete_dashboard" do
    it "requires the uid parameter" do
      expect {
        subject.delete_dashboard
      }.to raise_error(ArgumentError)
    end

    it "submits API request to delete w/ sepcified UID" do
      stub = stub_request(:delete, "https://test.grafana.io/api/dashboards/uid/testuid")
        .and_return(body: { "title": "Production Overview", "message": "Dashboard Production Overview deleted", "id": 2 }.to_json)

      subject.delete_dashboard(uid: 'testuid')

      expect(stub).to have_been_requested
    end
  end
end
