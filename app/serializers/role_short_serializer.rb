# == Schema Information
#
# Table name: roles
#
#  id   :bigint(8)        not null, primary key
#  name :string           not null
#

class RoleShortSerializer < ActiveModel::Serializer
  attributes :id, :name
end
