namespace :permissions do
  before "deploy:migrate", "permissions:load"

  task :load do
    on primary fetch(:migration_role) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, "permissions:load"
        end
      end
    end
  end
end
