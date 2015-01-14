$:.unshift File.expand_path('../lib', __FILE__)

# We test using RSpec
require 'rspec'

# We need Rack::MockRequest
require 'rack/mock'

# Rack::LocaleRootRedirect requires Rack::Accept
require 'rack/accept'

# We need Rack::LocaleRootRedirect
require 'rack-locale-root-redirect'

RSpec.configure do |config|
  # Disable `should` syntax
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
