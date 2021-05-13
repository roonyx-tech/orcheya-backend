module Admin
  class InvitationsController < Admin::BaseController
    before_action :set_user, only: %i[show update destroy]

    def create
      authorize User, policy_class: InvitationPolicy
      @user = User.invite!(user_params)
      if @user.errors.empty?
        render json: { invitation_url: @user.onboarding.invitation_url }
      else
        render json: @user.errors, status: :unprocessable_entity, adapter: :json
      end
    end

    def show
      authorize current_user, policy_class: InvitationPolicy
      render json: @user, include: '**', serializer: Admin::UserInvitationSerializer, adapter: :json
    end

    def update
      authorize @user, policy_class: InvitationPolicy

      if @user.update(user_params)
        render json: @user, include: '**', serializer: Admin::UserInvitationSerializer, adapter: :json
      else
        render json: { errors: @user.errors }, status: :unprocessable_entity
      end
    end

    def destroy
      authorize @user, policy_class: InvitationPolicy
      (@user.invitation_token && @user.really_destroy!) || @user.destroy
      head :ok
    end

    private

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      onboarding = [:id, :gmail_login, :gmail_password, step_ids: [], steps_attributes: %i[id name link kind]]
      fields = [:name, :surname, :name_cyrillic, :surname_cyrillic, :phone, :sex, :role, :timing_id, :email, :password,
                :encrypted_password, :birthday, :employment_at, :skype, :invitation_token, :working_hours,
                role_ids: [], onboarding_attributes: [onboarding]]
      params.require(:user).permit(fields)
    end
  end
end
