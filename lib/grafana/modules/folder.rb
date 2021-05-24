module Grafana
  module Modules
    module Folder
      def folders
        @conn.get('/api/folders')
      end

      def folder(uid:)
        @conn.get("/api/folders/#{uid}")
      end

      def create_folder(title:, uid: nil)
        req_body = {
          title: title
        }

        req_body.merge(uid: uid) if uid.present?

        @conn.post('/api/folders', req_body)
      end

      def update_folder(uid:, **options)
        # Drop any keys that are not valid for the request
        options = options.slice(:title, :new_uid, :version, :overwrite)
        options[:uid] = options.delete(:new_uid) if options.key(:new_uid)

        @conn.post("/api/folders/#{uid}", options)
      end

      def delete_folder(uid:)
        @conn.delete("/api/folders#{uid}")
      end
    end
  end
end

module Grafana
  class Folders< Client
    include Grafana::Modules::Folder
  end
end
