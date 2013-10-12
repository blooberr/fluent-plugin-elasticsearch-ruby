# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fluent-plugin-elasticsearch/version'

Gem::Specification.new do |gem|
  gem.name          = "fluent-plugin-elasticsearch-ruby"
  gem.version       = Fluent::Plugin::Elasticsearch::VERSION
  gem.authors       = ["Jon"]
  gem.email         = ["blooberr@gmail.com"]
  gem.description   = %q{Fluent plugin for elasticsearch}
  gem.summary       = %q{Use this plugin in conjunction with elasticsearch and fluentd to log events.}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
