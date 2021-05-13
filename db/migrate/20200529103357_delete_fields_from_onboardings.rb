class DeleteFieldsFromOnboardings < ActiveRecord::Migration[6.0]
  def change
    remove_column :onboardings, :discord_login, :string
    remove_column :onboardings, :discord_password, :string
    remove_column :onboardings, :discord_integration, :boolean
    remove_column :onboardings, :gitlab_tool, :boolean
    remove_column :onboardings, :jira_tool, :boolean
    remove_column :onboardings, :timedoctor_integration, :boolean
    remove_column :onboardings, :timedoctor_tool, :boolean
  end
end
