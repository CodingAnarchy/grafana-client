# frozen_string_literal: true

require_relative "lib/grafana/client/version"

Gem::Specification.new do |spec|
  spec.name          = "grafana-client"
  spec.version       = Grafana::CLIENT_VERSION
  spec.authors       = ["Matt Tanous"]
  spec.email         = ["mtanous22@gmail.com"]

  spec.summary       = "Client library for connections to Grafana API"
  spec.homepage      = "https://github.com/CodingAnarchy/grafana-client"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.5.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "https://github.com/CodingAnarchy/grafana-client/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'faraday', '~> 1.1'
  spec.add_dependency 'faraday_middleware', '~> 1.0'

  spec.add_development_dependency 'activesupport', '>= 5.2', '< 6.2'
  spec.add_development_dependency 'rspec', '~> 3.10'
  spec.add_development_dependency 'webmock', '~> 3.13'

  unless RUBY_PLATFORM == 'java'
    spec.add_development_dependency 'pry-byebug', '~> 3.9'
  end
end
