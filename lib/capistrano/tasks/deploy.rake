namespace :deploy do
  task :undeploy do
    on roles(:app) do
      invoke 'sidekiq:stop'
      invoke 'puma:stop'
      invoke 'whenever:clear_crontab'
      execute "dropdb #{fetch :db_name}" if fetch(:db_name)
      invoke 'nginx:site:disable'
      invoke 'nginx:site:remove'
      invoke 'nginx:reload'
      execute "rm -rf #{fetch(:deploy_to)}"
    end
  end

  namespace :nginx do
    after "puma:start", "deploy:nginx:setup"

    desc "Setup nginx config"
    task :setup do
      on roles(:app) do
        invoke 'nginx:site:add'
        invoke 'nginx:site:enable'
        invoke 'nginx:reload'
      end
    end
  end

  namespace :db do
    before "deploy:migrate", "deploy:db:load"
    before "deploy:check:linked_files", "deploy:db:yml"

    desc 'Generate database yml'
    task :yml => [:set_rails_env] do
      on primary :db do
        execute "mkdir -p #{shared_path.join('config')}" unless test("[ -d #{shared_path.join('config')} ]")

        db_yml = shared_path.join('config','database.yml')
        next if test(%Q[[ -e "#{db_yml}" ]])

        config_file = File.expand_path('../../../../config/deploy/templates/database.yml.erb', __FILE__)
        config = ERB.new(File.read(config_file)).result(binding)
        upload! StringIO.new(config), db_yml
      end
    end

    desc "Load the database schema if needed"
    task load: [:set_rails_env] do
      next unless fetch(:clone_db_from)
      on primary :db do
        if not test(%Q[[ -e "#{shared_path.join(".db_created")}" ]])
          within release_path do
            with rails_env: fetch(:rails_env) do
              execute "pg_dump -O -f #{shared_path.join("dump.sql")} #{fetch(:clone_db_from)}"
              execute "createdb #{fetch :db_name}"
              execute "psql -d #{fetch :db_name} -f #{shared_path.join("dump.sql")}"
              execute :touch, shared_path.join(".db_created")
            end
          end
        end
      end
    end
  end

  namespace :angular do
    after "deploy:assets:precompile", "angular:copy"

    desc "Load the angular app if needed"
    task copy: [:set_rails_env] do
      path = fetch(:angular_app_path)
      on primary :web do
        next unless path && !test("[ -d #{shared_path}/public/angular ]")
        execute "rsync -avz #{path}/ #{shared_path}/public/angular/"
      end
    end
  end
end
