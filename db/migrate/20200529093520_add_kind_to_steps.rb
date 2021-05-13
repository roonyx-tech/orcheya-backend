class AddKindToSteps < ActiveRecord::Migration[6.0]
  def change
    add_column :steps, :kind, :string
    add_column :steps, :description, :string
  end
end
