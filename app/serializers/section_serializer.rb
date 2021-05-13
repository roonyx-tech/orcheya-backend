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

class SectionSerializer < ActiveModel::Serializer
  attributes :id, :title, :image
  has_many :questions, serializer: QuestionSerializer
end
