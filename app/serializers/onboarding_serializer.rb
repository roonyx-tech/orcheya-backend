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

class OnboardingSerializer < ActiveModel::Serializer
  attributes :id, :gmail_login, :gmail_password

  has_many :onboarding_steps, serializer: OnboardingStepSerializer
end
