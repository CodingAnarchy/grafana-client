# Grafana::Client

Provide a Faraday-backed API client to interface with Grafana APIs to view and manage configurations of dashboards, data sources, and other means of collecting, querying and viewing data in Grafana.
## Installation

Add this line to your application's Gemfile:

```ruby
gem 'grafana-client'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install grafana-client

## Usage

`Grafana::Client` is configured initially by providing an API key and URL for the Grafana instance to connect with:

```ruby
Grafana::Client.config do |c|
  c.api_key = YOUR_GRAFANA_API_KEY
  c.grafana_url = YOUR_GRAFANA_INSTANCE_URL
end
```

This can then be used in a direct client instance, as for instance:

```ruby
client = Grafana::Client.new
client.dashboard(uid: DASHBOARD_UID)
```

An instance can also be created with specified credentials:

```ruby
client = Grafana::Client.new(grafana_url: url, api_key: API_KEY)
```

Clients can also be created with more limited scope, as with:

```ruby
dashboard_client = Grafana::Dashboards.new
alert_client = Grafana::Alerts.new
```

This can be used to provide more clear understanding of what resources are intended to be viewed or managed with the specified client.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

NOTE: THIS API CLIENT IS A WORK IN PROGRESS, WHICH CURRENTLY EXISTS AS A MINIMUM VIABLE PRODUCT FOR RELATED WORK PROJECTS. It may not currently meet your needs, as not all Grafana APIs are covered with the current implementation.

However, bug reports and pull requests are welcome on GitHub at https://github.com/CodingAnarchy/grafana-client, and a best effort will be made to respond in a timely manner.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
