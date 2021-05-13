class AddTempRefererToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :temp_referer, :string
  end
end
