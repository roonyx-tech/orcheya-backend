class AddRawInvitationTokenToOnboardings < ActiveRecord::Migration[6.0]
  def change
    add_column :onboardings, :raw_invitation_token, :string
  end
end
