class RemoveWayFromCoin < ActiveRecord::Migration[5.1]
  def change
    remove_column :coins, :way, :integer
  end
end
