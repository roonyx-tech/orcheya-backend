class ChangeTypeForEvent < ActiveRecord::Migration[5.1]
  def up
    Event.where(type: 'Events::Common').update_all(type: 'common')
    Event.where(type: 'Events::Holiday').update_all(type: 'holiday')
    Event.where(type: 'Events::Project').update_all(type: 'project')
    Event.where(type: 'Events::Vacation').update_all(type: 'vacation')
  end

  def down
    Event.where(type: 'common').update_all(type: 'Events::Common')
    Event.where(type: 'holiday').update_all(type: 'Events::Holiday')
    Event.where(type: 'project').update_all(type: 'Events::Project')
    Event.where(type: 'vacation').update_all(type: 'Events::Vacation')
  end
end
