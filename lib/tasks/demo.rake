namespace :demo do
  desc "Recreate data for demo env"
  task reset_data: :environment do
    %w[db:schema:load db:seed].each do |task|
      Rake::Task[task.to_sym].execute
    end
   puts "Done!"
  end
end
