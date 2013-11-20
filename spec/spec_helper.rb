$:.unshift File.expand_path('../lib', __FILE__)

require 'coveralls'
Coveralls.wear!

require 'rspec'
require 'rack/locale-root-redirect'

RSpec.configure do |config|
end
