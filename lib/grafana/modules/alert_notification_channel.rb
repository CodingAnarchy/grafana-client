module Grafana
  module Modules
    module AlertNotificationChannel
      def notification_channels
        @conn.get('/api/alert-notifications')
      end

      def notification_channel(uid:)
        @conn.get("/api/alert-notifications/uid/#{uid}")
      end

      def create_notification_channel(channel)
        # TODO: verify channel is a hash and has the expected values

        @conn.post('/api/alert-notifications', channel)
      end

      def update_notification_channel(channel, uid:)
        # TODO: verify channel is a hash and has the expected values

        @conn.post("/api/alert-notifications/uid/#{uid}", channel)
      end

      def delete_notification_channel(uid:)
        @conn.delete("/api/alert-notifications/uid/#{uid}")
      end

      def test_notification_channel(type:, settings:)
        # TODO: verify settings is a hash
        # TODO: verify type is supported notifier

        @conn.post('/api/alert-notifications/test', { type: type, settings: settings })
      end
    end
  end
end

module Grafana
  class NotificationChannels < BaseClient
    include Grafana::Modules::AlertNotificationChannel
  end
end
