class RemoveNilInUsers < ActiveRecord::Migration[5.1]
  def up
    User.where(vacation_days_initial: nil).update_all(vacation_days_initial: 0)
    User.where(vacation_days_used: nil).update_all(vacation_days_used: 0)
  end
end
