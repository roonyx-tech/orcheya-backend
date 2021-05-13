module Integration
  class TimedoctorController < ApplicationController
    skip_before_action :authenticate_user!

    def connect
      temp_token = SecureRandom.uuid

      current_user.update(
        temp_integration_token: temp_token,
        temp_referer: request.referer
      )

      uri = build_uri 'https://webapi.timedoctor.com/oauth/v2/auth',
                      client_id: Rails.application.credentials.timedoctor_client_id,
                      response_type: 'code',
                      state: temp_token,
                      redirect_uri: integration_timedoctor_callback_url

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
        TimeDoctorService.connect(user, params[:code], integration_timedoctor_callback_url)
        FetchWorklogsByYearJob.perform_later(user)
      end
    end

    def disconnect
      TimeDoctorService.new(current_user).disconnect
      render json: current_user, serializer: ProfileSerializer, adapter: :json
    end
  end
end
