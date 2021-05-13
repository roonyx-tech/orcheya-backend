class RenameOnboardingDocumentToOnboardingStep < ActiveRecord::Migration[6.0]
  def change
    rename_table :onboarding_documents, :onboarding_steps
  end
end
