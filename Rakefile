require 'pakyow-rake'

namespace :db do
  desc "Create and migrate the database"
  task :setup do
    puts "Setting up the database."

    %w(
    db:create
    db:migrate
    ).each {|t|
      puts "[Rake] #{t}"
      Rake::Task[t].invoke
    }
  end

  desc "Reset the database"
  task :reset do
    puts "Resetting the database."

    %w(
    db:drop
    db:setup
    ).each do |t|
      puts "[Rake] #{t}"
      Rake::Task[t].invoke
    end
  end

  desc "Drop the database"
  task :drop => [:terminate] do
    database = $db.opts[:database]
    $db.disconnect

    `dropdb #{database}`
  end

  desc "Create the database"
  task :create => [:'pakyow:prepare'] do
    database = $db.opts[:database]
    $db.disconnect

    `createdb #{database}`
  end

  desc "Migrate the database"
  task :migrate => [:'pakyow:prepare'] do
    flags = "-M #{ENV['VERSION']}" if ENV['VERSION']
    `sequel -m migrations #{ENV['DATABASE_URL']} #{flags}`
  end

  # via http://stackoverflow.com/questions/5108876/kill-a-postgresql-session-connection
  desc "Fix 'database is being accessed by other users'"
  task :terminate => [:'pakyow:prepare'] do
    unless $db.nil?
      $db.run <<-SQL
      SELECT
      pg_terminate_backend(pid)
      FROM
      pg_stat_activity
      WHERE
      -- don't kill my own connection!
      pid <> pg_backend_pid()
      -- don't kill the connections to other databases
      AND datname = '#{ENV['DB_NAME']}';
      SQL
    end
  end
end
