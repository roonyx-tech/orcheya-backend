class AddWorkStartDateToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :work_start_date, :datetime, default: Date.today

    reversible do |dir|
      dir.up { User.update_all('work_start_date = employment_at') }
    end
  end
end
