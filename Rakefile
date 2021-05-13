# Add your own tasks in files placed in services/tasks ending in .rake,
# for example services/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'

Rails.application.load_tasks

# Rubocop
if Rails.env.development? || Rails.env.test?
  require 'rubocop/rake_task'
  desc 'Run Rubocop lint checks'
  task :rubocop do
    RuboCop::RakeTask.new
  end
end
