module Integration
  class SlackController < ApplicationController
    skip_before_action :authenticate_user!

    def connect
      temp_token = SecureRandom.uuid
      current_user.update(
        temp_integration_token: temp_token,
        temp_referer: request.referer
      )

      uri = build_uri 'https://slack.com/oauth/authorize',
                      client_id: Rails.application.credentials.slack_client_id,
                      scope: 'identify',
                      state: temp_token,
                      redirect_uri: integration_slack_callback_url

      render json: { uri: uri }
    end

    def callback
      if params[:error].present?
        redirect_to Rails.application.credentials.frontend_url + '/profile?tab=settings'
      else
        user = User.find_by(temp_integration_token: params[:state])
        unless user&.temp_referer&.match? URI::DEFAULT_PARSER.make_regexp
          return redirect_to('/500', status: :not_acceptable)
        end
        redirect_to URI.parse(user.temp_referer).path
        SlackService.connect(user, exchange_codes)
      end
    end

    def disconnect
      SlackService.disconnect(current_user)
      render json: current_user, serializer: ProfileSerializer, adapter: :json
    end

    def slash
      raise StandardError, 'Unknown slash command'
    end

    private

    def exchange_codes
      uri = build_uri 'https://slack.com/api/oauth.access',
                      client_id: Rails.application.credentials.slack_client_id,
                      client_secret: Rails.application.credentials.slack_client_secret,
                      code: params[:code],
                      redirect_uri: integration_slack_callback_url

      data = Net::HTTP.get(uri)
      JSON.parse(data, symbolize_names: true)
    end
  end
end
