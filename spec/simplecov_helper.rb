require 'simplecov'

# Please, don't add files
TMP_EXCLUDE_FILES = %w[
  app/policies/application_policy.rb
  app/policies/events/holiday_policy.rb
  app/policies/events/project_policy.rb
  app/policies/events/vacation_policy.rb
  app/policies/event_policy.rb

  app/services/application_service.rb
  app/services/discord_service.rb
  app/services/worklog_service.rb
].freeze

SimpleCov.minimum_coverage 100
SimpleCov.start do
  coverage_dir 'tmp/coverage'
  add_filter '/.bundle/'
  add_filter '/db/'
  add_filter '/bots/'
  add_filter '/jobs/'
  add_filter '/uploaders/'
  add_filter '/serializers/'
  add_filter '/mailers/'
  add_filter '/spec/'
  add_filter '/config/'
  add_filter '/lib/'
  add_filter '/vendor/'
  add_filter do |src|
    filename = %r{^#{SimpleCov.root}\/(.*)}.match(src.filename).captures&.first
    !filename || filename.in?(TMP_EXCLUDE_FILES)
  end

  add_group 'Controllers', 'app/controllers'
  add_group 'Models', 'app/models'
  add_group 'Policies', 'app/policies'
  add_group 'Services', 'app/services'
  add_group 'Ignored Code' do |src_file|
    File.readlines(src_file.filename).grep(/:nocov:/).any?
  end

  track_files 'app/**/*.rb'
end
