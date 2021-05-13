class RenameDocumentToStep < ActiveRecord::Migration[6.0]
  def change
    rename_table :documents, :steps
  end
end
