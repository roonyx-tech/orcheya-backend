class ApplicationController < ActionController::Base
  include Pundit
  # after_action :verify_authorized, except: :index
  # after_action :verify_policy_scoped, only: :index

  include ActionController::MimeResponds
  impersonates :user

  before_action :prepare_exception_notifier
  before_action :authenticate_user!
  before_action :track_event

  respond_to :json

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from Pundit::NotAuthorizedError do |exception|
    policy_name = exception.policy && exception.policy.class.to_s.underscore || 'pundit'
    message = I18n.t("#{policy_name}.#{exception.query}", scope: 'pundit', default: :default)
    render json: { message: message }, status: :forbidden
  end

  def pagination_meta(collection)
    {
      pages: {
        current: collection.current_page,
        total: collection.total_pages
      },
      count: collection.count
    }
  end

  def build_uri(url, query)
    uri = URI(url)
    uri.query = URI.encode_www_form(query)
    uri
  end

  def track_event
    return unless request.method.in?(%w[POST PUT]) && response.successful? && current_user

    TrackEvent.track(current_user, "sa__#{controller_name}__#{action_name}")
  end

  private

  def prepare_exception_notifier
    request.env['exception_notifier.exception_data'] = {
      current_user: current_user.to_json(only: %i[id name surname email])
    }
  end

  def record_not_found
    head 404
  end
end
