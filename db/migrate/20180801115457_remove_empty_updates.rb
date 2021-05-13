class RemoveEmptyUpdates < ActiveRecord::Migration[5.1]
  def up
    Update.with_deleted.all.each do |update|
      unless update.made && update.planning && update.issues
        if update.made || update.planning || update.issues
          update.made ||= '-'
          update.planning ||= '-'
          update.issues ||= '-'
          update.save!(validate: false)
        else
          update.really_destroy!
        end
      end
    end
  end
end
