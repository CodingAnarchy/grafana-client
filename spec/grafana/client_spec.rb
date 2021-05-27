# frozen_string_literal: true

RSpec.describe Grafana::Client do
  it 'has a version number' do
    expect(Grafana::Client::VERSION).not_to be nil
  end

  %w(Alert AlertNotificationChannel Dashboard DataSource Folder).each do |mod|
    it "includes the #{mod} module" do
      expect(Grafana::Client).to include("Grafana::Modules::#{mod}".constantize)
    end
  end
end
