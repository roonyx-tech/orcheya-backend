# == Schema Information
#
# Table name: updates
#
#  id                 :bigint(8)        not null, primary key
#  date               :datetime
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  made               :string
#  planning           :string
#  issues             :string
#  user_id            :integer
#  deleted_at         :datetime
#  slack_ts           :string
#  discord_message_id :string
#
# Indexes
#
#  index_updates_on_deleted_at        (deleted_at)
#  index_updates_on_user_id_and_date  (user_id,date) UNIQUE
#
FAKER_TEXT = ['MR-25 add sms provider description to README',
              'OP-220 - Excess Override at the Occupation and Reseller level for every Product',
              'Enlarge business description input',
              'Past slots are not disabling in the current day if they are - fixed and deployed',
              'test and improve reminders logging. Improve Reminders logic. Changes deployed',
              'update timesheet',
              'RQ-1023 - Rating for beauty',
              'Add button to timesheet list',
              'Question mark information is missing',
              'Excess Override at the Occupation and Reseller level for every Product',
              'Change color palette',
              'Apply roster time to timesheet',
              'Fix issue with HABTM in Product model',
              'Broker fee does not increase with the increase of the Indemnity base rate',
              'fixed session_persistence parameter in credentials file',
              'Add twilio sms client',
              'Upgrade Rails and gems (Review)',
              'Change Languages to select inside Profile Details to English and French',
              '-'].freeze

FactoryBot.define do
  factory :update do
    user { User.random }
    made { FAKER_TEXT.sample }
    planning { FAKER_TEXT.sample }
    issues { FAKER_TEXT.sample }
    date { Date.current }
  end
end
