# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rack/locale-root-redirect'

Gem::Specification.new do |gem|
  gem.name          = "rack-locale-root-redirect"
  gem.version       = Rack::LocaleRootRedirect::VERSION
  gem.authors       = ["Rémi Prévost"]
  gem.email         = ["remi@exomel.com"]
  gem.description   = %q{Rack::LocaleRootRedirect uses Rack:Accept to map '/' to a path based on the `Accept-Language` HTTP header.}
  gem.summary       = gem.description
  gem.homepage      = "https://github.com/remiprev/rack-locale-root-redirect"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_runtime_dependency "rack-accept", ">= 0.4.5"
end
