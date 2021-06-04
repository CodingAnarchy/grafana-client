require 'spec_helper'

RSpec.describe Grafana::Modules::Dashboard do
  let(:test_class) { Class.new(Grafana::BaseClient) { include Grafana::Modules::Dashboard } }
  let(:example_dashboard) do
    {
      "dashboard": {
        "editable": false,
        "hideControls": true,
        "nav": [
          {
            "enable": false,
            "type": "timepicker"
          }
        ],
        "style": "dark",
        "tags": [],
        "templating": {
          "list": [
          ]
        },
        "time": {
        },
        "timezone": "browser",
        "title": "Home",
        "version": 5
      },
      "meta":	{
        "isHome": true,
        "canSave": false,
        "canEdit": false,
        "canStar": false,
        "url": "",
        "expires": "0001-01-01T00:00:00Z",
        "created": "0001-01-01T00:00:00Z"
      }
    }
  end
  
  subject(:test_client) { test_class.new }

  describe "#home_dashboard" do
    it "calls the home dashboard api" do
      stub = stub_request(:get, "https://test.grafana.io/api/dashboards/home")
        .to_return(body: example_dashboard.to_json, headers: {content_type: 'application/json'})

      dashboard = subject.home_dashboard

      expect(stub).to have_been_requested
      expect(dashboard).to eq(example_dashboard.deep_stringify_keys)
    end
  end

  describe "#create_dashboard" do
    it "submits the request to create a dashboard" do
      request_options = { 
        message: "Testing create dashboard",
        folder_id: 1
      }

      request_body = {
        dashboard: example_dashboard,
        message: request_options[:message],
        folderId: request_options[:folder_id],
        overwrite: false
      }

      response_body = {
        "id":      1,
        "uid":     "cIBgcSjkk",
        "url":     "/d/cIBgcSjkk/production-overview",
        "status":  "success",
        "version": 1,
        "slug":    "production-overview"
      }

      stub = stub_request(:post, "https://test.grafana.io/api/dashboards/db")
        .with(body: request_body.to_json)
        .and_return(status: 200, body: response_body.to_json, headers: {content_type: 'application/json'})

      response = subject.create_dashboard(dashboard: example_dashboard, **request_options)

      expect(stub).to have_been_requested
      expect(response).to eq(response_body.deep_stringify_keys)
    end
  end
  
  describe "#update_dashboard" do
    it "submits the request to create a dashboard" do
      request_options = { 
        title: "Updated dashboard via API",
        message: "Testing update dashboard",
        folder_id: 1
      }

      request_body = {
        dashboard: example_dashboard.merge({ title: "Updated dashboard via API" }),
        message: request_options[:message],
        folderId: request_options[:folder_id],
        overwrite: true
      }

      response_body = {
        "id":      1,
        "uid":     "testuid",
        "url":     "/d/testuid/production-overview",
        "status":  "success",
        "version": 1,
        "slug":    "production-overview"
      }

      get_stub = stub_request(:get, "https://test.grafana.io/api/dashboards/uid/testuid")
        .and_return(body: example_dashboard.to_json, headers: {content_type: 'application/json'})

      update_stub = stub_request(:post, "https://test.grafana.io/api/dashboards/db")
        .with(body: request_body.to_json)
        .and_return(status: 200, body: response_body.to_json, headers: {content_type: 'application/json'})

      response = subject.update_dashboard(uid: 'testuid', **request_options)

      expect(get_stub).to have_been_requested
      expect(update_stub).to have_been_requested
      expect(response).to eq(response_body.deep_stringify_keys)
    end
  end
  
  describe "#overwrite_dashboard" do
    it "submits the request to create a dashboard" do
      request_options = { 
        message: "Testing create dashboard",
        folder_id: 1
      }

      request_body = {
        dashboard: example_dashboard,
        message: request_options[:message],
        folderId: request_options[:folder_id],
        overwrite: true
      }

      response_body = {
        "id":      1,
        "uid":     "cIBgcSjkk",
        "url":     "/d/cIBgcSjkk/production-overview",
        "status":  "success",
        "version": 1,
        "slug":    "production-overview"
      }

      stub = stub_request(:post, "https://test.grafana.io/api/dashboards/db")
        .with(body: request_body.to_json)
        .and_return(status: 200, body: response_body.to_json, headers: {content_type: 'application/json'})

      response = subject.overwrite_dashboard(dashboard: example_dashboard, **request_options)

      expect(stub).to have_been_requested
      expect(response).to eq(response_body.deep_stringify_keys)
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
        .and_return(body: example_dashboard.to_json, headers: {content_type: 'application/json'})

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
        .and_return(body: { "title": "Production Overview", "message": "Dashboard Production Overview deleted", "id": 2 }.to_json,
                    headers: {content_type: 'application/json'})

      subject.delete_dashboard(uid: 'testuid')

      expect(stub).to have_been_requested
    end
  end

  describe "#dashboard_tags" do
    it "requests the available dashboard tags" do
      tags_response = [
        {
          "term" => "tag1",
          "count" => 1
        },
        {
          "term" => "tag2",
          "count" => 4
        }
      ]

      stub = stub_request(:get, "https://test.grafana.io/api/dashboards/tags")
        .and_return(body: tags_response.to_json, headers: {content_type: 'application/json'})

      response = subject.dashboard_tags

      expect(stub).to have_been_requested
      expect(response).to eq(tags_response)
    end
  end
end
