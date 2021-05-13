class RemoveOnboardingIdFromDocuments < ActiveRecord::Migration[6.0]
  def change
    remove_column :documents, :onboarding_id, type: :bigint
  end
end
