class RemoveCoins < ActiveRecord::Migration[5.2]
  def change
    drop_table :coins
  end
end
