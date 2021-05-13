# == Schema Information
#
# Table name: permission_subjects
#
#  id          :bigint(8)        not null, primary key
#  name        :string
#  title       :string
#  description :string
#

FactoryBot.define do
  factory :permission_subject do
    title { 'MyString' }
    description { 'MyString' }
  end
end
