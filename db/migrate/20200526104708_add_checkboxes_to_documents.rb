class AddCheckboxesToDocuments < ActiveRecord::Migration[6.0]
  def change
    add_column :documents, :default, :boolean
    remove_column :documents, :completed, :boolean
    add_column :onboarding_documents, :read, :boolean, default: false
  end
end
