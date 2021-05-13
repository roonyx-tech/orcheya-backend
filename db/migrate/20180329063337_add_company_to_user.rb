class AddCompanyToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :timedoctor_company_id, :integer
  end
end
