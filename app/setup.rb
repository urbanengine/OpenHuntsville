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

Sequel::Model.plugin :timestamps, update_on_create: true

Pakyow::App.define do
  configure :global do
    # put global config here and they'll be available across environments
    app.name = 'OpenHSV'

    # $db = Sequel.connect(ENV['DATABASE_URL'])
  end

  configure :development do
    server.port = 3001
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
  end
end
