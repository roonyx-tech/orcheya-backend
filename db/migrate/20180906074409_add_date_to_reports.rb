class AddDateToReports < ActiveRecord::Migration[5.1]
  def change
    add_column :reports, :started_at, :datetime
    add_column :reports, :ended_at, :datetime
  end
end
