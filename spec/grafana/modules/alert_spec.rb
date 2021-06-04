
require 'spec_helper'

RSpec.describe Grafana::Modules::Alert do
  let(:test_class) { Class.new(Grafana::BaseClient) { include Grafana::Modules::Alert } }
  let(:alerts_list) do
    [
      {
        "id" => 1,
        "dashboardId" => 1,
        "dashboardUId" => "ABcdEFghij",
        "dashboardSlug" => "sensors",
        "panelId" => 1,
        "name" => "fire place sensor",
        "state" => "alerting",
        "newStateDate" => "2018-05-14T05:55:20+02:00",
        "evalDate" => "0001-01-01T00:00:00Z",
        "evalData" => nil,
        "executionError" => "",
        "url" => "http://grafana.com/dashboard/db/sensors"
      }
    ]
  end
  let(:example_alert) do
    {
      "id": 1,
      "dashboardId": 1,
      "dashboardUId": "ABcdEFghij",
      "dashboardSlug": "sensors",
      "panelId": 1,
      "name": "fire place sensor",
      "state": "alerting",
      "message": "Someone is trying to break in through the fire place",
      "newStateDate": "2018-05-14T05:55:20+02:00",
      "evalDate": "0001-01-01T00:00:00Z",
      "evalData": "",
      "evalMatches": [
        {
          "metric": "movement",
          "tags": {
            "name": "fireplace_chimney"
          },
          "value": 98.765
        }
      ],
      "executionError": "",
      "url": "http://grafana.com/dashboard/db/sensors"
    }
  end

  subject(:test_client) { test_class.new }

  describe "#alerts" do
    it "requests all alerts if no query params" do
      stub = stub_request(:get, "https://test.grafana.io/api/alerts?state=ALL")
        .and_return(body: alerts_list.to_json, headers: { content_type: 'application/json' })

      response = test_client.alerts

      expect(stub).to have_been_requested
      expect(response).to eq(alerts_list)
    end

    it "requests with panel id" do
      stub = stub_request(:get, "https://test.grafana.io/api/alerts?panelId=1&state=ALL")
        .and_return(body: alerts_list.to_json, headers: { content_type: 'application/json' })

      test_client.alerts(panel_id: 1)

      expect(stub).to have_been_requested
    end

    context "with folder ids" do
      it "requests singular" do
        stub = stub_request(:get, "https://test.grafana.io/api/alerts?folderId=1&state=ALL")
          .and_return(body: alerts_list.to_json, headers: { content_type: 'application/json' })

        test_client.alerts(folder_id: 1)

        expect(stub).to have_been_requested
      end

      it "requests multiple" do
        stub = stub_request(:get, "https://test.grafana.io/api/alerts?folderId=0&folderId=1&state=ALL")
          .and_return(body: alerts_list.to_json, headers: { content_type: 'application/json' })

        test_client.alerts(folder_id: [0, 1])

        expect(stub).to have_been_requested
      end
    end

    context "with dashboard ids" do
      it "requests singular" do
        stub = stub_request(:get, "https://test.grafana.io/api/alerts?dashboardId=1&state=ALL")
          .and_return(body: alerts_list.to_json, headers: { content_type: 'application/json' })

        test_client.alerts(dashboard_id: 1)

        expect(stub).to have_been_requested
      end

      it "requests multiple" do
        stub = stub_request(:get, "https://test.grafana.io/api/alerts?dashboardId=0&dashboardId=1&state=ALL")
          .and_return(body: alerts_list.to_json, headers: { content_type: 'application/json' })

        test_client.alerts(dashboard_id: [0, 1])

        expect(stub).to have_been_requested
      end
    end
  end

  describe "#alert" do
    it "requires the id parameter" do
      expect {
        subject.alert
      }.to raise_error(ArgumentError)
    end

    it "returns a dashboard from the specified uid" do
      stub = stub_request(:get, "https://test.grafana.io/api/alerts/1")
        .and_return(body: example_alert.to_json, headers: { content_type: 'application/json' })

      alert = subject.alert(id: 1)

      expect(stub).to have_been_requested
      expect(alert).to eq(example_alert.deep_stringify_keys)
    end
  end

  describe "#pause_alert" do
    it "requires the id parameter" do
      expect {
        subject.pause_alert
      }.to raise_error(ArgumentError)
    end

    it "requests a pause for the alert" do
      stub = stub_request(:post, "https://test.grafana.io/api/alerts/1/pause")
        .with(body: { paused: true }.to_json)
        .and_return(body: { "alertId": 1, "state": "Paused", "message": "alert paused" }.to_json, 
                    headers: { content_type: 'application/json' })

      pause = subject.pause_alert(id: 1)

      expect(stub).to have_been_requested
    end
    
    it "requests an un pause for the alert if paused = false" do
      stub = stub_request(:post, "https://test.grafana.io/api/alerts/1/pause")
        .with(body: { paused: false }.to_json)
        .and_return(body: { "alertId": 1, "state": "Paused", "message": "alert paused" }.to_json,
                    headers: { content_type: 'application/json' })

      pause = subject.pause_alert(id: 1, paused: false)

      expect(stub).to have_been_requested
    end
  end

  describe "#unpause_alert" do
    it "requires the id parameter" do
      expect {
        subject.unpause_alert
      }.to raise_error(ArgumentError)
    end

    it "requests an unpause for the alert" do
      stub = stub_request(:post, "https://test.grafana.io/api/alerts/1/pause")
        .with(body: { paused: false }.to_json)
        .and_return(body: { "alertId": 1, "state": "Paused", "message": "alert paused" }.to_json,
                    headers: { content_type: 'application/json' })

      pause = subject.pause_alert(id: 1, paused: false)

      expect(stub).to have_been_requested
    end
  end
end
