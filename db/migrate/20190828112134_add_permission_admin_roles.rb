class AddPermissionAdminRoles < ActiveRecord::Migration[5.1]
  def up
    Rake::Task['permissions:load'].invoke
    permission_roles = Permission.find_by(subject: 'admin', action: 'roles')
    roles = Role.where(name: ['COO', 'CTO', 'CEO', 'Main PM'])
    roles.each do |role|
      role.permissions << permission_roles
    end
  end
end
