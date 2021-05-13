class AddBirthdayNotifyToRoles < ActiveRecord::Migration[5.1]
  def change
    add_column :roles, :is_birthday_notify, :boolean, default: false
  end
end
