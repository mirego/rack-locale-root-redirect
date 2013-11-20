# Rack::LocaleRootRedirect

`Rack::LocaleRootRedirect` redirects requests to `"/"` based on the `Accept-Language` HTTP header.

## Installation

Add this line to your application’s Gemfile:

```ruby
gem 'rack-locale-root-redirect', require: 'rack/locale-root-redirect'
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
gem "rack-accept", require: "rack/accept"
gem "rack-locale-root-redirect", require: "rack/locale-root-redirect"

# config.ru
require 'bundler'
Bundler.require

class MyApp < Sinatra::Base
  use Rack::Accept
  use Rack::LocaleRootRedirect, fr: "/fr", en: "/en"

  get("/fr") { "Français!" }
  get("/en") { "English!" }
end

run MyApp
```

Then, test it:

```shell
$ rackup &

$ curl -sI "http://0.0.0.0:9292" -H "Accept-Language: fr;q=1, en;q=0.8" | grep "301\|Location"
HTTP/1.1 301 Moved Permanently
Location: /fr

$ curl -sI "http://0.0.0.0:9292" -H "Accept-Language: fr;q=0.4, en;q=0.8" | grep "301\|Location"
HTTP/1.1 301 Moved Permanently
Location: /en
```
