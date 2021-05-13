# == Schema Information
#
# Table name: permissions
#
#  id          :bigint(8)        not null, primary key
#  subject     :string
#  action      :string
#  description :string
#

class Permission < ApplicationRecord
  has_many :permissions_roles, dependent: :delete_all
  has_many :roles, through: :permissions_roles
  has_many :users, -> { distinct }, through: :roles

  def title
    "#{subject}: #{action}"
  end

  class << self
    def users_by(value)
      subject, action = value.split(':')
      permission = Permission.find_by(subject: subject, action: action)
      permission&.users || User.none
    end
  end
end
