TimeDoctor::Config.configure do |conf|
  conf.client_id = Rails.application.credentials.timedoctor_client_id
  conf.client_secret = Rails.application.credentials.timedoctor_client_secret

  conf.on_token_refresh = lambda do |data, payload|
    payload[:user].update timedoctor_token: data[:access_token],
                          timedoctor_refresh_token: data[:refresh_token]
  end

  conf.on_token_refresh_error = lambda do |_, payload|
    user = payload[:user]

    user.update timedoctor_token: nil,
                timedoctor_refresh_token: nil,
                timedoctor_company_id: nil,
                timedoctor_user_id: nil

    TimedoctorNotifier.notify(:broken, recipient: user)
  end
end
