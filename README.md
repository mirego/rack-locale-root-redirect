# Rack::LocaleRootRedirect

[![Build Status](https://travis-ci.org/mirego/rack-locale-root-redirect.png?branch=master)](https://travis-ci.org/mirego/rack-locale-root-redirect)
[![Coverage Status](https://coveralls.io/repos/mirego/rack-locale-root-redirect/badge.png)](https://coveralls.io/r/mirego/rack-locale-root-redirect)
[![Ruby Gem](https://badge.fury.io/rb/rack-locale-root-redirect.png)](https://rubygems.org/gems/microscope)

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
gem 'sinatra'
gem 'rack-locale-root-redirect'

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

[Mirego](http://mirego.com) is a team of passionate people who believe that work is a place where you can innovate and have fun. We're team of [talented people](http://life.mirego.com) who imagine and build beautiful web and mobile applications. We come together to share ideas and [change the world](http://mirego.org).

We also [love open-source software](http://open.mirego.com) and we try to give back to the community as much as we can.
