class ChangeTypeDate < ActiveRecord::Migration[5.1]
  def up
    change_column :worklogs, :date, 'TIMESTAMP USING date::TIMESTAMP'
  end

  def down
    change_column :worklogs, :date, 'DATE USING date::DATE'
  end
end
