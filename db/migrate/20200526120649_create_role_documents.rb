class CreateRoleDocuments < ActiveRecord::Migration[6.0]
  def change
    create_table :role_documents do |t|
      t.belongs_to :role
      t.belongs_to :document
      t.timestamps
    end
  end
end
