class CreateOnboardings < ActiveRecord::Migration[5.2]
  def change
    create_table :onboardings do |t|
      t.string :gmail_login
      t.string :gmail_password
      t.string :discord_login
      t.string :discord_password
      t.boolean :jira_tool
      t.boolean :gitlab_tool
      t.boolean :timedoctor_tool
      t.boolean :discord_integration
      t.boolean :timedoctor_integration
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
