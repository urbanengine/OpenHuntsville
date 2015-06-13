require 'bundler/setup'

require 'pakyow'
require 'sequel'
Sequel::Model.plugin :timestamps, update_on_create: true

Pakyow::App.define do
  configure :global do
    # put global config here and they'll be available across environments
    app.name = 'Pakyow'
  end

  configure :development do
    require 'dotenv'
    Dotenv.load

    $db = Sequel.connect(ENV['DATABASE_URL'])
  end

  configure :prototype do
    # an environment for running the front-end prototype with no backend
    app.ignore_routes = true
  end

  configure :staging do
    # put your staging config here
  end

  configure :production do
    # put your production config here
  end
end
