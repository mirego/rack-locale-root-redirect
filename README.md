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
gem 'sinatra'
gem 'rack-accept', require: 'rack/accept'
gem 'rack-locale-root-redirect', require: 'rack/locale-root-redirect'

# config.ru
require 'bundler'
Bundler.require

class MyApp < Sinatra::Base
  use Rack::Accept
  use Rack::LocaleRootRedirect, fr: "/fr", en: "/en"

  get('/fr') { 'Français!' }
  get('/en') { 'English!' }
end

run MyApp
```

Then, test it:

```shell
$ rackup &

$ curl -sI "http://0.0.0.0:9292" -H "Accept-Language: fr;q=1, en;q=0.8" | grep "302\|Location"
HTTP/1.1 302 Moved Permanently
Location: /fr

$ curl -sI "http://0.0.0.0:9292" -H "Accept-Language: fr;q=0.4, en;q=0.8" | grep "302\|Location"
HTTP/1.1 302 Moved Permanently
Location: /en
```

## License

`Rack::LocaleRootRedirect` is © 2013 [Mirego](http://www.mirego.com) and may be freely distributed under the [New BSD license](http://opensource.org/licenses/BSD-3-Clause).  See the [`LICENSE.md`](https://github.com/mirego/rack-locale-root-redirect/blob/master/LICENSE.md) file.

## About Mirego

Mirego is a team of passionate people who believe that work is a place where you can innovate and have fun. We proudly build mobile applications for [iPhone](http://mirego.com/en/iphone-app-development/ "iPhone application development"), [iPad](http://mirego.com/en/ipad-app-development/ "iPad application development"), [Android](http://mirego.com/en/android-app-development/ "Android application development"), [Blackberry](http://mirego.com/en/blackberry-app-development/ "Blackberry application development"), [Windows Phone](http://mirego.com/en/windows-phone-app-development/ "Windows Phone application development") and [Windows 8](http://mirego.com/en/windows-8-app-development/ "Windows 8 application development") in beautiful Quebec City.

We also love [open-source software](http://open.mirego.com/) and we try to extract as much code as possible from our projects to give back to the community.
