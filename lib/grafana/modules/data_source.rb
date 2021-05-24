module Grafana
  module Modules
    module DataSource
      def data_sources
        @conn.get('/api/datasources')
      end

      def data_source(uid:)
        @conn.get("/api/datasources/uid/#{uid}")
      end

      def named_data_source(name:)
        @conn.get("/api/datasources/name/#{name}")
      end

      def create_data_source(data_source)
        @conn.post('/api/datasources', data_source)
      end

      def delete_data_source(uid:)
        @conn.delete("/api/datasources/uid/#{uid}")
      end
    end
  end
end

module Grafana
  class DataSources < BaseClient
    include Grafana::Modules::DataSource
  end
end
