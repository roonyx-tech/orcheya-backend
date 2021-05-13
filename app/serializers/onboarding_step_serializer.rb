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

class OnboardingStepSerializer < ActiveModel::Serializer
  attributes :id, :read, :name, :link, :kind, :step_id

  def name
    return if object.step.blank?
    object.step.name
  end

  def link
    return if object.step.blank?
    object.step.link
  end

  def kind
    return if object.step.blank?
    object.step.kind
  end

  def step_id
    return if object.step.blank?
    object.step.id
  end
end
