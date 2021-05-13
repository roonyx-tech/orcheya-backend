class UserInvitationSerializer < ActiveModel::Serializer
  attributes :id, :name, :surname

  has_one :onboarding, serializer: OnboardingSerializer

  def discord_connected
    object.discord_connected?
  end

  def slack_connected
    object.slack_connected?
  end

  def timedoctor_connected
    object.timedoctor_connected?
  end
end
