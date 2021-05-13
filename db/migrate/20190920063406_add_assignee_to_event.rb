class AddAssigneeToEvent < ActiveRecord::Migration[5.2]
  def up
    add_reference :events, :assignee, foreign_key: { to_table: :users }
    Event.update_all("assignee_id = user_id")
  end

  def down
    remove_reference :events, :assignee, foreign_key: { to_table: :users }
  end
end
