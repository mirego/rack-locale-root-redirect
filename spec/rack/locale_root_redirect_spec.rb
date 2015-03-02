require 'spec_helper'

describe Rack::LocaleRootRedirect do
  let(:app) { proc{[200,{},['Hello, world.']]} }
  let(:request) { Rack::MockRequest.new(stack) }

  context 'with stack using Rack::Accept' do
    let(:stack) { Rack::LocaleRootRedirect.new(Rack::Accept.new(app), locales) }

    describe 'response' do
      let(:locales) { { fr: '/fr', en: '/en' } }
      let(:response) { request.get('/?foo=bar', 'HTTP_ACCEPT_LANGUAGE' => accept_language.join(',')) }

      context 'with first matching language' do
        let(:accept_language) { %w{en es;q=0.9} }
        it { expect(response.headers['Location']).to eq '/en?foo=bar' }
        it { expect(response.headers['Vary']).to eq 'Accept-Language'}
      end

      context 'with second matching language' do
        let(:accept_language) { %w{es en;q=0.8} }
        it { expect(response.headers['Location']).to eq '/en?foo=bar' }
        it { expect(response.headers['Vary']).to eq 'Accept-Language'}
      end

      context 'with default matching language' do
        let(:accept_language) { %w{es jp;q=0.8} }
        it { expect(response.headers['Location']).to eq '/fr?foo=bar' }
        it { expect(response.headers['Vary']).to eq 'Accept-Language'}
      end
    end
  end

  context 'with stack without Rack::Accept' do
    let(:locales) { { fr: '/fr', en: '/en' } }
    let(:stack) { Rack::LocaleRootRedirect.new(app, locales) }

    specify do
      expect { request.get('/') }.to raise_error(StandardError, Rack::LocaleRootRedirect::RACK_ACCEPT_MISSING)
    end
  end
end
