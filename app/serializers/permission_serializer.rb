# == Schema Information
#
# Table name: permissions
#
#  id          :bigint(8)        not null, primary key
#  subject     :string
#  action      :string
#  description :string
#

class PermissionSerializer < ActiveModel::Serializer
  attributes :id, :subject, :action, :description
end
