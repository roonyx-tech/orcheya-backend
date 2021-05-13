# == Schema Information
#
# Table name: holidays
#
#  id   :bigint(8)        not null, primary key
#  date :date
#  name :string
#

FactoryBot.define do
  factory :holiday do
    date { Date.current }
    name { 'MyHoliday' }
  end
end
