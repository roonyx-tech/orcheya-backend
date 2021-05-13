module Admin
  class UserInvitationIndexSerializer < ActiveModel::Serializer
    attributes :id, :name, :surname, :email, :invitation_url

    def invitation_url
      return if object.onboarding.blank?
      object.onboarding.invitation_url
    end
  end
end
