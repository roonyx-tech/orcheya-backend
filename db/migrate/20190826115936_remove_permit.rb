class RemovePermit < ActiveRecord::Migration[5.1]

  class Permit < ApplicationRecord
  end

  class PermitsRole < ApplicationRecord
  end

  def up
    Permit.find_each do |permit|
      permission = Permission.find_or_create_by(subject: 'depricated', action: permit.id)
      role_ids = PermitsRole.where(permit_id: permit.id).pluck(:role_id)
      permission.role_ids = role_ids
      permission.save!
    end
    drop_table :permits
    drop_table :permits_roles
    Rake::Task['permissions:load'].invoke
  end

  def down
  #   No way
  end
end
