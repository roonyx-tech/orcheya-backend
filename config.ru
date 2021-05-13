# This file is used by Rack-based servers to start the application.

require_relative 'config/environment'

Thread.new do
  Discord.new.run
end

run Rails.application
