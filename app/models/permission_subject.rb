# == Schema Information
#
# Table name: permission_subjects
#
#  id          :bigint(8)        not null, primary key
#  name        :string
#  title       :string
#  description :string
#

class PermissionSubject < ApplicationRecord
  has_many :permissions,
           primary_key: :name,
           foreign_key: :subject,
           dependent: :destroy,
           inverse_of: false
end
