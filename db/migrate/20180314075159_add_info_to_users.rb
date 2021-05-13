class AddInfoToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :name, :string, null: false, default: ""
    add_column :users, :surname, :string, null: false, default: ""
    add_column :users, :birthday, :date
    add_column :users, :employment_at, :date
    add_column :users, :sex, :integer
    add_column :users, :github, :string
    add_column :users, :bitbucket, :string
    add_column :users, :skype, :string
    add_column :users, :phone, :string
    add_column :users, :timing, :integer
  end
end
