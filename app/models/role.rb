# == Schema Information
#
# Table name: roles
#
#  id   :bigint(8)        not null, primary key
#  name :string           not null
#

class Role < ApplicationRecord
  has_many :roles_users, dependent: :delete_all
  has_many :users, -> { distinct }, through: :roles_users
  has_many :permissions_roles, dependent: :delete_all
  has_many :permissions, through: :permissions_roles
  has_many :achievements_roles, dependent: :destroy
  has_many :achievements, through: :achievements_roles
  has_many :role_steps, dependent: :destroy
  has_many :steps, through: :role_steps

  validates :name, presence: true
end
