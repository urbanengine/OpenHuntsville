require 'bundler/setup'

require 'pakyow-support'
require 'pakyow-core'
require 'pakyow-presenter'
require 'pakyow-mailer'

require 'sequel'
require 'sequel/extensions/pg_json'

require 'httparty'

require 'mailgun'
require 'aws-sdk'
require "mini_magick"
require 'rack/ssl'

# Mailchimp
require 'gibbon'

require 'omniauth'
require 'omniauth-auth0'

Sequel::Model.plugin :timestamps, update_on_create: true

Pakyow::App.define do
  configure :global do
    # put global config here and they'll be available across environments
    app.name = 'OpenHSV'
    
    Gibbon::Request.timeout = 15
    Gibbon::Request.open_timeout = 15
    Gibbon::Request.throws_exceptions = false
    # $db = Sequel.connect(ENV['DATABASE_URL'])
  end

  configure :development do
    server.port = 3000
    require 'dotenv'
      Dotenv.load
      $db = Sequel.connect(ENV['DATABASE_URL'])
  end

  configure :prototype do
    # an environment for running the front-end prototype with no backend
    app.ignore_routes = true
  end

  configure :production do
    app.static = true
    # realtime.redis = { url: ENV['REDIS_URL'] }
    app.log_output = true
    app.auto_reload = false
    app.errors_in_browser = false

    $db = Sequel.connect(ENV['DATABASE_URL'])
  end

  middleware do |builder|
    builder.use Rack::Session::Cookie,
      :key => 'ws.session',
      :secret => 'ae3fe3aacd5e45ffb0865db10522ee6be33c9cb9951547ec90bc6480015141e3'

    builder.use OmniAuth::Builder do
      provider(
        :auth0,
        ENV['AUTH0_CLIENT_ID']'PhhE0E_Mk0G_K6ezui57741qracK-sI9',
        ENV['AUTH0_CLIENT_SECRET'],
        ENV['AUTH0_DOMAIN']'urbanengine.auth0.com',
        callback_path: "/auth/auth0/callback",
        authorize_params: {
          scope: 'openid profile',
          audience: 'https://urbanengine.auth0.com/userinfo'
        }
      )
    end
  end
end
