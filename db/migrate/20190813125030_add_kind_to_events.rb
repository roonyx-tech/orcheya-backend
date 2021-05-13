class AddKindToEvents < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :kind, :integer, default: 0
  end
end
