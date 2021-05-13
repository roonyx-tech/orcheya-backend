# == Schema Information
#
# Table name: roles_users
#
#  id         :bigint(8)        not null, primary key
#  role_id    :bigint(8)
#  user_id    :bigint(8)
#  deleted_at :datetime
#
# Indexes
#
#  index_roles_users_on_deleted_at  (deleted_at)
#  index_roles_users_on_role_id     (role_id)
#  index_roles_users_on_user_id     (user_id)
#

class RolesUser < ApplicationRecord
  acts_as_paranoid

  belongs_to :role
  belongs_to :user
end
