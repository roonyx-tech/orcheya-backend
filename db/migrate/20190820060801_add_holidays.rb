class AddHolidays < ActiveRecord::Migration[5.1]
  def up
    Events::Holiday.generate(Date.current.beginning_of_year, 5.years.from_now)
  end

  def down
    Events::Holiday.delete_all
  end
end
