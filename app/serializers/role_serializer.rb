# == Schema Information
#
# Table name: roles
#
#  id   :bigint(8)        not null, primary key
#  name :string           not null
#

class RoleSerializer < ActiveModel::Serializer
  attributes :id, :name, :permissions, :users_count

  def users_count
    object.users.count
  end
end
