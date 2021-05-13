class RemoveSuperAdminPermission < ActiveRecord::Migration[5.1]
  def up
    permission_holidays = Permission.find_by(subject: 'calendar', action: 'holidays')
    roles = Role.where(name: ['COO', 'CTO', 'CEO', 'HR', 'Main PM'])
    roles.each do |role|
      role.permissions << permission_holidays
    end
  end
end
