module Grafana
  module Modules
    module Folder
      def folder_search(**options)
        options = options.slice(:query, :tag, :dashboard_ids, :folder_ids, :starred, :limit, :page)

        options[:folderIds] = Array.wrap(options.delete(:folder_ids)) if options[:folder_ids].present?
        options[:dashboardIds] = Array.wrap(options.delete(:dashboard_ids)) if options[:dashboard_ids].present?

        options.delete(:starred) unless options[:starred].is_a?(Boolean)
        options.delete(:limit) unless options[:limit].is_a?(Integer) && options[:limit] <= 5000
        options.delete(:page) unless options[:page].is_a?(Integer)

        options.merge({ type: 'dash-folder' })

        search_url = '/api/search'
        search_url = "?#{URI.encode_www_form(options)}"
        get(search_url)
      end
      def folders
        get('/api/folders')
      end

      def folder(uid:)
        get("/api/folders/#{uid}")
      end

      def create_folder(title:, uid: nil)
        req_body = {
          title: title
        }

        req_body.merge(uid: uid) if uid.present?

        post('/api/folders', req_body)
      end

      def update_folder(uid:, **options)
        # Drop any keys that are not valid for the request
        options = options.slice(:title, :new_uid, :version, :overwrite)
        options[:uid] = options.delete(:new_uid) if options.key(:new_uid)

        post("/api/folders/#{uid}", options)
      end

      def delete_folder(uid:)
        delete("/api/folders#{uid}")
      end
    end
  end
end

module Grafana
  class Folders < BaseClient
    include Grafana::Modules::Folder
  end
end
