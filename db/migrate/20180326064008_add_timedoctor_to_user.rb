class AddTimedoctorToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :timedoctor_token, :string
    add_column :users, :timedoctor_refresh_token, :string
  end
end
