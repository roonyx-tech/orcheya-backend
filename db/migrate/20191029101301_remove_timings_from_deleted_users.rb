class RemoveTimingsFromDeletedUsers < ActiveRecord::Migration[5.2]
  def up
    User.only_deleted.each { |user| user.update_attribute(:timing_id, nil) }
  end
end
