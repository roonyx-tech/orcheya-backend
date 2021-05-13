class AddComponyWalletInQuest < ActiveRecord::Migration[5.1]
  def change
    add_column :quests, :company_wallet, :boolean, default: false
  end
end
