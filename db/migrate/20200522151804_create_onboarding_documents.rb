class CreateOnboardingDocuments < ActiveRecord::Migration[6.0]
  def change
    create_table :onboarding_documents do |t|
      t.belongs_to :onboarding
      t.belongs_to :document
      t.timestamps
    end
  end
end
