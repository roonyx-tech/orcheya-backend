class UpdateService
  attr_reader :user, :params

  def self.create(user, params)
    new(user, nil, params).create
  end

  def self.update(user, update, params)
    new(user, update, params).update
  end

  def initialize(user, update, params)
    @user = user
    @update = update
    @params = params
  end

  def create
    @update = @user.updates.create(@params)

    if @update.persisted?
      send_update_to_channel
      link_update_with_projects
    end

    @update
  end

  def update
    send_update_to_channel if @update.update(@params)
    @update
  end

  private

  def link_update_with_projects
    projects_ids = user.worklogs.where(date: params[:date]).distinct.pluck(:project_id)

    projects_ids.each do |f|
      UpdateProject.create(update_id: @update.id, project_id: f)
    end
  end

  def send_update_to_channel
    SendUpdateToDiscordJob.perform_later(@update) if user.discord_notify_update
    SendUpdateToSlackJob.perform_later(@update) if user.notify_update
  end
end
