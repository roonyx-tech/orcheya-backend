class ChangeSystemOfUsers < ActiveRecord::Migration[5.1]
  def change
    change_column :users, :system, :boolean, default: false
    User.where(system: nil).update_all(system: false)
  end
end
