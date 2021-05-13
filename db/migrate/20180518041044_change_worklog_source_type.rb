class ChangeWorklogSourceType < ActiveRecord::Migration[5.1]
  def change
    change_column :worklogs, :source, 'integer USING source::integer'
  end
end
