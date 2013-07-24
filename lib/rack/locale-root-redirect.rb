require "rack/accept"

module Rack
  class LocaleRootRedirect
    VERSION = "0.0.4"

    def initialize(app, locales = {})
      @locales = locales
      @available_locales = locales.keys.map(&:to_s)
      @default_locale = @available_locales.first
      @app = app
    end

    def call(env)
      status, headers, response = @app.call(env)

      if match_data = %r[\A/(?<query_string>\?.*|\Z)].match(env["REQUEST_URI"])
        language_matcher = env['rack-accept.request'].language
        language_matcher.first_level_match = true
        redirect_lang = language_matcher.best_of(@available_locales) || @default_locale

        status = 302
        headers["Location"] = @locales[redirect_lang.to_sym] + match_data[:query_string]
      end

      [status, headers, response]
    end
  end
end
