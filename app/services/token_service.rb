class TokenService
  include Singleton

  attr_reader :tokens

  def initialize
    @tokens = {}
  end

  def find_or_generate(user)
    find_valid(user) || generate(user)
  end

  def find_valid(user)
    token = tokens[user.id]
    return nil if token.blank?

    payload = Warden::JWTAuth::TokenDecoder.new.call(token)
    Time.zone.at(payload['exp']) < Time.zone.now ? nil : token
  end

  def generate(user)
    scope ||= Devise::Mapping.find_scope!(user)
    token, payload = Warden::JWTAuth::UserEncoder.new.call(user, scope, nil)
    user.respond_to?(:on_jwt_dispatch) && user.on_jwt_dispatch(token, payload)
    tokens[user.id] = token
    token
  end

  def clear
    @tokens = {}
  end
end
