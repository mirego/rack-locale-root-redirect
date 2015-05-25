module Rack
  class LocaleRootRedirect
    STATUS = 302
    ROOT_REQUEST_REGEX = %r{\A/(?<query_string>\?.*|\Z)}
    RACK_ACCEPT_MISSING = 'Rack::LocaleRootRedirect must be used after Rack::Accept. Please make your application use Rack::Accept before Rack::LocaleRootRedirect.'
    REDIRECTED_RESPONSE_REGEX = %r{\A3\d\d\Z}

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

      if should_redirect?(env, status)
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
    def should_redirect?(env, status)
      !redirected_response?(status) && root_request?(env)
    end

    # Return whether the request was on the root endpoint (`/`)
    def root_request?(env)
      ROOT_REQUEST_REGEX.match(env['PATH_INFO'])
    end

    # Return whether the response we’re altering is already a redirection
    def redirected_response?(status)
      REDIRECTED_RESPONSE_REGEX.match(status.to_s)
    end

    # Return the best locale to redirect to based on the request enviroment
    def best_locale(env)
      if accept = env['rack-accept.request']
        matcher = accept.language.tap { |m| m.first_level_match = true }
        matcher.best_of(@available_locales) || @default_locale
      else
        raise StandardError, RACK_ACCEPT_MISSING
      end
    end
  end
end
