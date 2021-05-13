module LoginHelpers
  def token(user)
    return nil unless defined?(user) && user
  end

  def Authorization # rubocop:disable Naming/MethodName
    return nil unless defined?(logged_user) && logged_user
    accept_invite(logged_user)
    create_token(logged_user)
  end

  def user_params
    return nil unless defined?(user) && user
    accept_invite(user)
    { user: user.slice(:email, :password) }
  end

  def invitation_token
    return nil unless defined?(invited_user) && invited_user
    create_invite(invited_user)
  end
end

private

def create_invite(user)
  raw, enc = Devise.token_generator.generate(user.class, :invitation_token)
  user.update(invitation_token: enc)
  raw
end

def accept_invite(user)
  user.update(password: '123456',
              invitation_token: nil,
              invitation_accepted_at: user.invitation_sent_at)
end

def create_token(user)
  scope = Devise::Mapping.find_scope!(user)
  token = Warden::JWTAuth::UserEncoder.new.call(user, scope, nil).first
  "Bearer #{token}"
end
