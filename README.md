# Rack::LocaleRootRedirect

`Rack::LocaleRootRedirect` redirects requests to `"/"` based on the `Accept-Language` HTTP header.

## Installation

Add this line to your application’s Gemfile:

```ruby
gem 'rack-locale-root-redirect'
```

And then execute:

```shell
$ bundle
```

## Usage

With Sinatra:

```ruby
# Gemfile
gem "sinatra"
gem "rack-accept", :require => "rack/accept"
gem "rack-locale-root-redirect", :require => "rack/locale-root-redirect"

# config.ru
require 'bundler'
Bundler.require

class MyApp < Sinatra::Base
  use Rack::Accept
  use Rack::LocaleRootRedirect, :fr => "/fr", :en => "/en"

  get("/fr") { "Français!" }
  get("/en") { "English!" }
end

run MyApp
```
