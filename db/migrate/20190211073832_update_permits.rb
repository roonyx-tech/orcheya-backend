class UpdatePermits < ActiveRecord::Migration[5.1]
  def up
    Rake::Task['permits:load'].invoke
  end
end
