namespace :roles do
  desc 'Init roles'
  task init: :environment do
    member = Role.create name: 'Member'
    admin  = Role.create name: 'Admin', is_admin: true

    kasparov = User.find_by surname: 'Kasparov'

    kasparov.update(role_id: admin.id)
    User.where.not(id: kasparov.id).update_all(role_id: member.id)

    Role.destroy(Role.where.not(id: [member, admin]).ids)
  end
end
