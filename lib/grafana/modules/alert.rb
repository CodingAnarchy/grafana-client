require 'uri'

module Grafana
  module Modules
    module Alert
      def alerts(**options)
        options = options.slice(:folder_id, :dashboard_id, :panel_id, :query, :state, 
                                :limit, :dashboard_query, :dasboard_tag).compact

        valid_alert_states = ['ALL', 'no_data', 'paused', 'alerting', 'ok', 'pending']

        options[:folderId] = Array.wrap(options.delete(:folder_id)) if options[:folder_id].present?
        options[:dashboardId] = Array.wrap(options.delete(:dashboard_id)) if options[:dashboard_id].present?
        options[:dasboardQuery] = options.delete(:dahsboard_query) if options[:dashboard_query].present?
        options[:dashboardTag] = Array.wrap(options.delete(:dashboard_tag)) if options[:dashboard_tag].present?
        options[:state] = Array.wrap(options[:state] || 'ALL') & valid_alert_states

        options.delete(:limit) unless options[:limit].is_a?(Integer)

        alert_url = '/api/alerts'
        alert_url += URI.encode_www_form(options) if options.any?
        @conn.get(alert_url)
      end

      def alert(id:)
        @conn.get("/api/alerts/#{id}")
      end

      # CRUD actions are done in alerts via modifying the associated dashboard
      # TODO: create CRUD actions in client that will do the appropriate lookups and changes more directly

      def pause_alert(id:, paused: true)
        @conn.post("/api/alerts/#{id}/pause", { paused: paused })
      end
    end
  end
end

module Grafana
  class Alerts < BaseClient
    include Grafana::Modules::Alert
  end
end
