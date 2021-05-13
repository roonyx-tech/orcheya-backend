class RenameDocumentFieldsToStep < ActiveRecord::Migration[6.0]
  def change
    rename_column :onboarding_steps, :document_id, :step_id
    rename_column :role_steps, :document_id, :step_id
  end
end
