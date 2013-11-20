require 'spec_helper'

describe Rack::LocaleRootRedirect do
  let(:app) { proc{[200,{},['Hello, world.']]} }
  let(:stack) { Rack::LocaleRootRedirect.new(Rack::Accept.new(app), locales) }
  let(:request) { Rack::MockRequest.new(stack) }

  describe 'response' do
    let(:locales) { { fr: '/fr', en: '/en' } }
    let(:response) { request.get('/?foo=bar', 'HTTP_ACCEPT_LANGUAGE' => accept_language.join(',')) }

    context 'with first matching language' do
      let(:accept_language) { %w{en es;q=0.9} }
      it { expect(response.headers['Location']).to eq '/en?foo=bar' }
    end

    context 'with second matching language' do
      let(:accept_language) { %w{es en;q=0.8} }
      it { expect(response.headers['Location']).to eq '/en?foo=bar' }
    end

    context 'with default matching language' do
      let(:accept_language) { %w{es jp;q=0.8} }
      it { expect(response.headers['Location']).to eq '/fr?foo=bar' }
    end
  end
end
