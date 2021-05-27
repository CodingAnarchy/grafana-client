module Grafana
  module Modules
    module Folder
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
