$:.unshift File.expand_path('../lib', __FILE__)

require 'coveralls'
Coveralls.wear!

# We test using RSpec
require 'rspec'

# We need Rack::MockRequest
require 'rack/mock'

# Rack::LocaleRootRedirect requires Rack::Accept
require 'rack/accept'

# We need Rack::LocaleRootRedirect
require 'rack-locale-root-redirect'

RSpec.configure do |config|
end
