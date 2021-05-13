# == Schema Information
#
# Table name: timings
#
#  id       :bigint(8)        not null, primary key
#  start    :time
#  end      :time
#  flexible :boolean          default(FALSE), not null
#

FactoryBot.define do
  factory :timing do
    add_attribute(:start) { '08:00 +0300' }
    add_attribute(:end) { '17:00 +0300' }
  end
end
