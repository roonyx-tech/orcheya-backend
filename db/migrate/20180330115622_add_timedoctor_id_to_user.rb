class AddTimedoctorIdToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :timedoctor_user_id, :integer
  end
end
