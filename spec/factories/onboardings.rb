# == Schema Information
#
# Table name: onboardings
#
#  id                   :bigint(8)        not null, primary key
#  gmail_login          :string
#  gmail_password       :string
#  user_id              :bigint(8)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  invitation_url       :string
#  raw_invitation_token :string
#
# Indexes
#
#  index_onboardings_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#

FactoryBot.define do
  factory :onboarding do
    gmail_login { 'MyString' }
    gmail_password { 'MyString' }
    user { nil }
    raw_invitation_token { 'sample' }
  end
end
