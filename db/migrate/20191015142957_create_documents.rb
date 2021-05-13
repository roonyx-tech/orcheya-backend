class CreateDocuments < ActiveRecord::Migration[5.2]
  def change
    create_table :documents do |t|
      t.string :name
      t.string :link
      t.boolean :completed, default: false
      t.references :onboarding, foreign_key: true

      t.timestamps
    end
  end
end
