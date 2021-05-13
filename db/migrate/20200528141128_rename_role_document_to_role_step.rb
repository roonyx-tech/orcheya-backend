class RenameRoleDocumentToRoleStep < ActiveRecord::Migration[6.0]
  def change
    rename_table :role_documents, :role_steps
  end
end
