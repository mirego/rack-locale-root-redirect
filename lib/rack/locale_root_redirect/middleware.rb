module Rack
  class LocaleRootRedirect
    STATUS = 302
    REGEX = %r[\A/(?<query_string>\?.*|\Z)]
    RACK_ACCEPT_MISSING = 'Rack::LocaleRootRedirect must be used after Rack::Accept. Please make your application use Rack::Accept before Rack::LocaleRootRedirect.'

    # @private
    def initialize(app, locales = {})
      @locales = locales
      @available_locales = locales.keys.map(&:to_s)
      @default_locale = @available_locales.first

      @app = app
    end

    # @private
    def call(env)
      status, headers, response = @app.call(env)

      if root_request?(env)
        locale = best_locale(env)

        status = STATUS
        query_string = env['QUERY_STRING'] == '' ? '' : "?#{env['QUERY_STRING']}"
        headers['Vary'] = 'Accept-Language'
        headers['Location'] = @locales[locale.to_sym] + query_string
      end

      [status, headers, response]
    end

  protected

    # Return whether we must act on this request
    def root_request?(env)
      REGEX.match(env['PATH_INFO'])
    end

    # Return the best locale to redirect to based on the request enviroment
    def best_locale(env)
      if accept = env['rack-accept.request']
        matcher = accept.language.tap do |matcher|
          matcher.first_level_match = true
        end

        matcher.best_of(@available_locales) || @default_locale
      else
        raise StandardError.new(RACK_ACCEPT_MISSING)
      end
    end
  end
end
