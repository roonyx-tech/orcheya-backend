# == Schema Information
#
# Table name: steps
#
#  id          :bigint(8)        not null, primary key
#  name        :string
#  link        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  default     :boolean
#  kind        :string
#  description :string
#

FactoryBot.define do
  factory :step do
    name { 'MyString' }
    link { 'MyString' }
    default { false }
    kind { %w[document tool].sample }
  end
end
