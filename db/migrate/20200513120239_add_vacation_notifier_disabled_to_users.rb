class AddVacationNotifierDisabledToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :vacation_notifier_disabled, :boolean, default: false
  end
end
