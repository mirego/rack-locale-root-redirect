require 'spec_helper'

describe Rack::LocaleRootRedirect do
  let(:request) { Rack::MockRequest.new(stack) }
  let(:locales) { { fr: '/fr', en: '/en' } }

  context 'with stack using Rack::Accept' do
    let(:stack) { Rack::LocaleRootRedirect.new(Rack::Accept.new(app), locales) }
    let(:response) { request.get('/?foo=bar', 'HTTP_ACCEPT_LANGUAGE' => accept_language.join(',')) }

    context 'with response already being redirected' do
      let(:app) { proc { [301, { 'Location' => '/new-place' }, ['You are being redirected...']] } }

      describe 'response headers' do
        let(:accept_language) { %w() }
        it { expect(response.headers['Location']).to eq '/new-place' }
        it { expect(response.headers['Vary']).to be_nil }
      end
    end

    context 'with response not already being redirected' do
      let(:app) { proc { [200, {}, ['Hello, world.']] } }

      describe 'response headers' do
        context 'with first matching language' do
          let(:accept_language) { %w(en es;q=0.9) }
          it { expect(response.headers['Location']).to eq '/en?foo=bar' }
          it { expect(response.headers['Vary']).to eq 'Accept-Language' }
        end

        context 'with second matching language' do
          let(:accept_language) { %w(es en;q=0.8) }
          it { expect(response.headers['Location']).to eq '/en?foo=bar' }
          it { expect(response.headers['Vary']).to eq 'Accept-Language' }
        end

        context 'with default matching language' do
          let(:accept_language) { %w(es jp;q=0.8) }
          it { expect(response.headers['Location']).to eq '/fr?foo=bar' }
          it { expect(response.headers['Vary']).to eq 'Accept-Language' }
        end
      end
    end
  end

  context 'with stack without Rack::Accept' do
    let(:app) { proc { [200, {}, ['Hello, world.']] } }
    let(:stack) { Rack::LocaleRootRedirect.new(app, locales) }

    specify do
      expect { request.get('/') }.to raise_error(StandardError, Rack::LocaleRootRedirect::RACK_ACCEPT_MISSING)
    end
  end
end
