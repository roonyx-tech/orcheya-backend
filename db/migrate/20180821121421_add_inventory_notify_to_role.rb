class AddInventoryNotifyToRole < ActiveRecord::Migration[5.1]
  def change
    add_column :roles, :is_inventory_notify, :boolean, default: false
  end
end
