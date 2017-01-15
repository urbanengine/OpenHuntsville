require File.expand_path('../app/setup.rb', __FILE__)

$stdout.sync = true

app = Pakyow::App
app.builder.run(app.stage(ENV['RACK_ENV']))
run app.builder.to_app
