################################## OVERVIEW ##################################
# This rakefile contains all Heroku specific commands.
#
# To deploy the app, run the following command:
#   rake heroku:migrate  OR  rake heroku:restart
# 
# 
# To copy data from Production to Staging environment, just run the following command:
#   rake db:staging:production_refresh
##############################################################################

namespace :heroku do
  
  task :reset, :app_name do |t, args|
    "heroku pg:reset PRODUCTION_URL --confirm #{args.app_name}"
      %w(
    seed:experts
    seed:admins
    ).each do |t|
      puts "[Rake] #{t}"
      Rake::Task[t].invoke
    end
  end
 
  task :migrate, :app_name do |t, args|
    Rake::Task["heroku:rake"].invoke("db:migrate --trace", args.app_name)
  end
 
  task :restart, :app_name do |t, args|
    run_command("restart", args.app_name)
  end
 
  #  Runs rake tasks for Heroku applications
  task :rake, :cmd, :app_name do |t, args|
    run_command("run rake #{args.cmd}", args.app_name)
  end
 
  def run_command(cmd, app_name)
    Bundler.with_clean_env do
      sh build_command(cmd, app_name)
    end
  end
 
  def run_command_with_output(cmd, app_name)
    Bundler.with_clean_env do
      `#{build_command(cmd, app_name)}`
    end.gsub("\n", "")
  end
 
  def build_command(cmd, app_name)
    "heroku #{cmd} --app #{app_name}"
  end
 
# Copies db data from one app to another in Heroku
  namespace :pgbackups do
    task :restore, :app_name, :database_name do |t, args|
      production_url = run_command_with_output("pgbackups:url", ENV["production_app"])
      run_command("pgbackups:restore #{args.database_name} '#{production_url}' --confirm #{args.app_name}", args.app_name)
    end
  end
 
end