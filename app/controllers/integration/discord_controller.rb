module Integration
  class DiscordController < ApplicationController
    skip_before_action :authenticate_user!

    def connect
      temp_token = SecureRandom.uuid
      current_user.update!(
        temp_integration_token: temp_token,
        temp_referer: request.referer
      )

      uri = build_uri('https://discordapp.com/api/oauth2/authorize',
                      client_id: Rails.application.credentials.discord_client_id,
                      redirect_uri: integration_discord_callback_url,
                      state: temp_token,
                      response_type: 'code',
                      scope: 'identify')
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
        DiscordService.connect(user, exchange_codes)
      end
    end

    def disconnect
      DiscordService.disconnect(current_user)
      render json: current_user, serializer: ProfileSerializer, adapter: :json
    end

    def exchange_codes
      uri = URI.parse('https://discordapp.com/api/oauth2/token')
      data = {
        client_id: Rails.application.credentials.discord_client_id,
        client_secret: Rails.application.credentials.discord_client_secret,
        grant_type: 'authorization_code',
        code: params[:code],
        redirect_uri: integration_discord_callback_url,
        scope: 'identify'
      }

      data = Net::HTTP.post_form(uri, data)
      JSON.parse(data.body, symbolize_names: true)
    end
  end
end
