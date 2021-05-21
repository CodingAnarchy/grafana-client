# frozen_string_literal: true

module Grafana
  module Modules
    module Dashboard
      def home_dashboard
        @conn.get('/api/dashboards/home')
      end

      def create_dashboard(dashboard, **options)
        # TODO: Error if dashboard is not hash specification
        # TODO: error if dashboard IDs are set (should be an update if so)

        req_body = {
          dashboard: dashboard,
          message: options[:message],
          folderId: options[:folder_id],
          overwrite: false # Creating new dashboard should not overwrite existing dashboards
        }

        @conn.post('/api/dashboards/db', req_body)
      end

      def get_dashboard_by_uid(uid)
        @conn.get("/api/dashboards/uid/#{uid}")
      end

      def delete_dashboard_by_uid(uid)
        @conn.delete("/api/dashboards/uid/#{uid}")
      end

      def dashboard_tags
        @conn.get('/api/dashboards/tags')
      end
    end
  end
end

module Grafana
  class Dashboard < Client
    include Grafana::Modules::Dashboard
  end
end
