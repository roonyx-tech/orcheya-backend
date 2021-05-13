class AddFieldsToTiming < ActiveRecord::Migration[5.1]
  def up
    add_column :timings, :start, :time
    add_column :timings, :end, :time
    add_column :timings, :flexible, :boolean, null: false, default: false

    Timing.all.each do |time|
      params = if time.time == 'flexible'
                 { flexible: true }
               else
                 { start: time.time.split.first + ' +0300',
                   end: time.time.split.last + ' +0300',
                   flexible: false }
               end

      time.update! params
    end

    remove_column :timings, :time
  end

  def down
    add_column :timings, :time, :string

    Timing.all.each do |time|
      params = if time.flexible?
                 'flexible'
               else
                 "#{time.start.strftime('%H:%M')} - #{time.end.strftime('%H:%M')}"
               end

      time.update! time: params
    end

    remove_column :timings, :start
    remove_column :timings, :end
    remove_column :timings, :flexible
  end
end
