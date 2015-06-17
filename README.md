Huntsville's consultants, moonlighters, service firms and business advisors.

# Getting Started

## Install Ruby, Ruby Gems, PostgreSQL and Pakyow

- [Ruby 2.47](http://www.ruby-lang.org/en/downloads/)
- [Ruby Gems](http://rubygems.org/pages/download)
- [PostgreSQL](http://www.postgresql.org/)
- `gem install pakyow`

## Set up DB

- Create Postgres DB
- Copy .env.example to .env and edit to contain your Postgres peoplename, password and database
- From the hntsvll directory, run the rake reset `rake db:reset`

## Running the application

Start the app server in the command line:

  `bundle exec pakyow server`

You'll find your app running at [http://localhost:3000](http://localhost:3000)!

## Creating data

- Go to [http://localhost:3000/people/new](http://localhost:3000/people/new)
- Fill out the form and submit
- Go to [http://localhost:3000/logout](http://localhost:3000/logout)
- Repeat

## Need to interact with your app? Fire up a console:

  `pakyow console`

# Next Steps

The following resources might be handy:

- [Website](http://pakyow.com)
- [Warmup](http://pakyow.com/warmup)
- [Docs](http://pakyow.com/docs)
- [Code](http://github.com/metabahn/pakyow)
