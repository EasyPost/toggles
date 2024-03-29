# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'toggles/version'

Gem::Specification.new do |s|
  s.name = 'toggles'
  s.version = Toggles::VERSION
  s.authors = ['Andrew Tribone', 'James Brown', 'Josh Lane']
  s.summary = 'YAML backed feature toggles'
  s.email = 'oss@easypost.com'
  s.homepage = 'https://github.com/EasyPost/toggles'
  s.license = 'ISC'
  s.files = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  s.test_files = s.files.grep(%r{^(spec)/})
  s.description = <<-EOF
    YAML-backed implementation of the feature flags pattern. Build a
    hierarchy of features in YAML files in the filesystem, apply various
    conditions using boolean logic and a selection of filters, and easily
    check whether a given feature should be applied.
  EOF

  s.add_development_dependency 'bundler', '~> 2.0'
  s.add_development_dependency 'rake', '~> 13.0'
  s.add_development_dependency 'rspec', '~> 3.10'
  s.add_development_dependency 'rspec-its', '~> 1.3'
  s.add_development_dependency 'rspec-temp_dir', '~> 1.1'
end
