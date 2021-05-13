# == Schema Information
#
# Table name: sections
#
#  id         :bigint(8)        not null, primary key
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  image      :string
#

class Section < ApplicationRecord
  mount_base64_uploader :image, ImageUploader

  has_many :questions, dependent: :destroy

  validates :title, presence: true

  accepts_nested_attributes_for :questions, allow_destroy: true
end
