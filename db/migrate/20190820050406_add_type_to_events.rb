class AddTypeToEvents < ActiveRecord::Migration[5.1]
  def up
    add_column :events, :type, :string
    Event.where(kind: 'vacation').update_all(type: 'Events::Vacation')
    Event.where(kind: ['project', nil]).update_all(type: 'Events::Common')
    remove_column :events, :kind, :integer
  end

  def down
    add_column :events, :kind, :integer
    Event.where(type: 'Events::Vacation').update_all(kind: 'vacation')
    Event.where(type: 'Events::Common').update_all(kind: 'project')
    remove_column :events, :type, :string
  end
end
