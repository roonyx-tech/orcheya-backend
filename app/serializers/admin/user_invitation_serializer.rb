module Admin
  class UserInvitationSerializer < ActiveModel::Serializer
    attributes :id,
               :email,
               :name,
               :surname,
               :name_cyrillic,
               :surname_cyrillic,
               :employment_at,
               :sex,
               :phone,
               :timing_id,
               :working_hours,
               :roles,
               :invitation_url

    belongs_to :timing, serializer: TimingIndexSerializer
    has_many :roles, serializer: RoleShortSerializer
    has_one :onboarding, serializer: OnboardingSerializer

    def invitation_url
      return if object.onboarding.blank?
      object.onboarding.invitation_url
    end
  end
end
