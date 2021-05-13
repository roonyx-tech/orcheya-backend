class EventsController < ApplicationController
  before_action :set_event, only: %i[show update destroy approve disapprove]
  after_action :send_notification, except: %i[index]

  # rubocop:disable Metrics/AbcSize
  def index
    events = policy_scope(Event)
    events = events.joins(:user).where(users: { id: user_ids_params }) if user_ids_params.present?
    events = events.where(type: params[:type]) if params[:type].present?
    events = events.overlap(index_params[:start], index_params[:finish]) if params[:start] && params[:finish]
    events = events.includes(:user, :assignee, :project).order(started_at: :asc)
    render json: events, each_serializer: EventSerializer
  end
  # rubocop:enable Metrics/AbcSize

  def create
    @event = event_class.new(user_id: current_user.id)
    @event.assign_attributes(permitted_attributes(@event))
    @event.assignee = current_user
    authorize @event

    if @event.save(context: validation_context)
      render json: @event, serializer: EventSerializer
    else
      render json: @event.errors, status: :unprocessable_entity
    end
  end

  def show
    authorize @event
    render json: @event, serializer: EventSerializer
  end

  def update
    authorize @event
    @event.assign_attributes(permitted_attributes(@event))

    if @event.save(context: validation_context)
      render json: @event, serializer: EventSerializer
    else
      render json: @event.errors, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @event
    @event.destroy
    head :ok
  end

  def approve
    authorize @event
    @event.assignee = current_user
    @event.status = :approved
    @event.save!
    render json: @event, serializer: EventSerializer
  end

  def disapprove
    authorize @event
    @event.assignee = current_user
    @event.status = :canceled
    @event.description = params[:description]
    if @event.save
      render json: @event, serializer: EventSerializer
    else
      render json: @event.errors, status: :unprocessable_entity
    end
  end

  private

  def send_notification
    return unless @event&.errors&.empty?

    VacationNotifier.notify(action_name, event: @event) if @event.type.eql?('vacation')
  end

  def validation_context
    event_policy = policy(@event)

    if event_policy.manage_all?
      :manager_submission
    elsif @event.is_a?(Events::Project) && event_policy.manage_projects?
      :manager_submission
    elsif @event.user_id == current_user.id
      :personal_submission
    end
  end

  def pundit_params_for(_record)
    params.require(:event)
  end

  def index_params
    params.permit(:start, :finish).tap do |p|
      p[:start] = p[:start] && p[:start].to_date
      p[:finish] = p[:finish] && p[:finish].to_date
    end
  end

  def tag_ids_params
    parse_ids(params[:tag_ids])
  end

  def user_ids_params
    parse_ids(params[:user_ids])
  end

  def parse_ids(data)
    data ? data.split(',') : nil
  end

  def set_event
    @event = Event.find(params[:id])
  end

  def event_class
    kind = params.require(:type)
    Event::TYPES[kind.to_sym].constantize
  end
end
