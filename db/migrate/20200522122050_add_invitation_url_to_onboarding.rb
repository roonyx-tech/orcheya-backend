class AddInvitationUrlToOnboarding < ActiveRecord::Migration[6.0]
  def change
    add_column :onboardings, :invitation_url, :string
  end
end
