module Users
  class InvitationsController < ApplicationController
    skip_before_action :authenticate_user!
    before_action :set_user

    def show
      render json: @user,
             include: '**',
             serializer: UserInvitationSerializer,
             format: :json
    end

    def update
      if @user.update(user_params)
        accept_invitation if @user.password.present?
        tokenize(@user)
        render json: @user, serializer: UserInvitationSerializer, format: :json
      else
        render json: { errors: @user.errors }, status: :unprocessable_entity
      end
    end

    private

    def accept_invitation
      @user.accept_invitation!
      @onboarding.update(raw_invitation_token: nil)
    end

    def set_user
      @onboarding = Onboarding.find_by!(raw_invitation_token: params[:user_token])
      @user = @onboarding.user
    end

    def user_params
      doc = %i[id read]
      onboarding = [:id, onboarding_steps_attributes: [doc]]
      fields = [:password, :encrypted_password, :avatar, onboarding_attributes: [onboarding]]
      params.require(:user).permit(fields)
    end

    def tokenize(user)
      scope = Devise::Mapping.find_scope!(user)
      token = "Bearer #{Warden::JWTAuth::UserEncoder.new.call(user, scope, nil).first}"
      response.set_header('authorization', token)
    end
  end
end
