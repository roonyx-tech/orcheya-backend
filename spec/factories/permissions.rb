# == Schema Information
#
# Table name: permissions
#
#  id          :bigint(8)        not null, primary key
#  subject     :string
#  action      :string
#  description :string
#

FactoryBot.define do
  factory :permission do
    subject { 'MyString' }
    action { 'MyString' }
  end
end
