class AddAgreementAcceptedAndRegistrationFinished < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :registration_finished, :boolean, default: false
  end
end
