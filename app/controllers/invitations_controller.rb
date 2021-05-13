class InvitationsController < Devise::InvitationsController
  skip_before_action :resource_from_invitation_token
  skip_before_action :authenticate_user!

  def update
    user = invited_user

    if user.persisted? && user.valid?
      tokenize(user)
      render json: user, serializer: ProfileSerializer, adapter: :json, status: :created
    else
      render json: { errors: user.errors }, status: :not_acceptable
    end
  end

  private

  def invited_user
    User.accept_invitation!(
      invitation_token: params[:invitation_token],
      password: params[:password] || '',
      name: params[:name],
      surname: params[:surname],
      timing_id: params[:timing_id]
    )
  end

  def tokenize(user)
    scope = Devise::Mapping.find_scope!(user)
    token = "Bearer #{Warden::JWTAuth::UserEncoder.new.call(user, scope, nil).first}"
    response.set_header('authorization', token)
  end
end
