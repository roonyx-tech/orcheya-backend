# == Schema Information
#
# Table name: permission_subjects
#
#  id          :bigint(8)        not null, primary key
#  name        :string
#  title       :string
#  description :string
#

class PermissionSubjectSerializer < ActiveModel::Serializer
  attributes :name, :title, :description

  has_many :permissions, key: :actions, serializer: PermissionSerializer
end
