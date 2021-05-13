# == Schema Information
#
# Table name: onboarding_steps
#
#  id            :bigint(8)        not null, primary key
#  onboarding_id :bigint(8)
#  step_id       :bigint(8)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  read          :boolean          default(FALSE)
#
# Indexes
#
#  index_onboarding_steps_on_onboarding_id  (onboarding_id)
#  index_onboarding_steps_on_step_id        (step_id)
#

class OnboardingStep < ApplicationRecord
  belongs_to :step
  belongs_to :onboarding
end
