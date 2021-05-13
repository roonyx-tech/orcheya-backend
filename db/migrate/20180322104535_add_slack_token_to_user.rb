class AddSlackTokenToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :temp_integration_token, :string
    add_column :users, :slack_token, :string
  end
end
