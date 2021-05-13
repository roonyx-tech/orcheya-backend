# == Schema Information
#
# Table name: questions
#
#  id         :bigint(8)        not null, primary key
#  title      :string
#  section_id :bigint(8)        not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_questions_on_section_id  (section_id)
#
# Foreign Keys
#
#  fk_rails_...  (section_id => sections.id)
#

class Question < ApplicationRecord
  belongs_to :section
  has_one :answer, dependent: :destroy

  validates :title, presence: true, length: { maximum: 500 }

  accepts_nested_attributes_for :answer
end
