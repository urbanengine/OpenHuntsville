require File.expand_path('../app/setup.rb', __FILE__)

app = Pakyow::App
app.builder.run(app.stage(ENV['RACK_ENV']))
run app.builder.to_app
