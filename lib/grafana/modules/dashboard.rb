# frozen_string_literal: true

module Grafana
  module Modules
    module Dashboard
      def home_dashboard
        get('/api/dashboards/home')
      end

      def create_dashboard(dashboard:, **options)
        # TODO: Error if dashboard is not hash specification
        # TODO: error if dashboard IDs are set (should be an update if so)

        req_body = {
          dashboard: dashboard,
          message: options[:message],
          folderId: options[:folder_id],
          overwrite: false # Creating new dashboard should not overwrite existing dashboards
        }

        post('/api/dashboards/db', req_body)
      end

      def update_dashboard(uid:, **options)
        message = options.delete(:message)
        folder_id = options.delete(:folder_id)

        old_dashboard = dashboard(uid: uid)

        req_body = {
          dashboard: old_dashboard.merge(options),
          message: message,
          folderId: folder_id,
          overwrite: true # Updating dashboard should overwrite existing dashboards
        }

        post('/api/dashboards/db', req_body)
      end

      def overwrite_dashboard(dashboard:, **options)
        req_body = {
          dashboard: dashboard,
          message: options[:message],
          folderId: options[:folder_id],
          overwrite: true # Overwriting dashboard (if exists)
        }

        post('/api/dashboards/db', req_body)
      end

      def dashboard_search(**options)
        options = options.slice(:query, :tag, :dashboard_ids, :folder_ids, :starred, :limit, :page)

        options[:folderIds] = Array.wrap(options.delete(:folder_ids)) if options[:folder_ids].present?
        options[:dashboardIds] = Array.wrap(options.delete(:dashboard_ids)) if options[:dashboard_ids].present?

        options.delete(:starred) unless options[:starred].is_a?(Boolean)
        options.delete(:limit) unless options[:limit].is_a?(Integer) && options[:limit] <= 5000
        options.delete(:page) unless options[:page].is_a?(Integer)

        options.merge({ type: 'dash-db' })

        search_url = '/api/search'
        search_url = "?#{URI.encode_www_form(options)}"
        get(search_url)
      end

      def dashboard(uid:)
        get("/api/dashboards/uid/#{uid}")
      end

      def delete_dashboard(uid:)
        delete("/api/dashboards/uid/#{uid}")
      end

      def dashboard_tags
        get('/api/dashboards/tags')
      end

      def dashboard_permissions(dashboard_id:)
        get("/api/dashboards/id/#{dashboard_id}/permissions")
      end

      def update_dashboard_permissions(dashboard_id:, permissions:)
        # TODO: error if permissions is not array of hashes
        post("/api/dashboards/id/#{dashboard_id}/permissions", { items: permissions })
      end

      def dashboard_versions(dashboard_id:)
        get("/api/dashboards/id/#{dashboard_id}/versions")
      end

      def dashboard_version(dashboard_id:, version_id:)
        get("/api/dashboards/id/#{dashboard_id}/versions/#{version_id}")
      end

      def restore_dashboard_version(dashboard_id:, version_id:)
        post("/api/dashboards/id/#{dashboard_id}/restore", { version: version_id })
      end

      def diff_dashboards(base_id:, base_version:, new_version:, new_id: nil, diff_type: 'json')
        req_body = {
          base: {
            dashboardId: base_id,
            version: base_version
          },
          new: {
            dashboardId: new_id || base_id,
            version: new_version
          },
          diffType: diff_type
        }

        post('/api/dashboards/calculate-diff', req_body)
      end
    end
  end
end

module Grafana
  class Dashboards < BaseClient
    include Grafana::Modules::Dashboard
  end
end
