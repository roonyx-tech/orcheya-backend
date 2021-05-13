class CreateTiming < ActiveRecord::Migration[5.1]
  def change
    create_table :timings do |t|
      t.string :time
    end

    add_column :users, :timing_id, :integer
    add_foreign_key :users, :timings, column: :timing_id, primary_key: :id

    User.all.each do |user|
      user.update(timing_id: Timing.find_or_create_by(time: user.timing).id)
    end

    remove_column :users, :timing
  end
end
