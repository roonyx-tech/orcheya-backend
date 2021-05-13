class DashboardIndexSerializer < ActiveModel::Serializer
  attributes :id, :name, :surname, :name_cyrillic, :surname_cyrillic, :avatar, :worktime

  has_many :roles, serializer: RoleShortSerializer

  def worktime
    @worktime = Users::WorktimeService.new(object)
    {
      working_time: @worktime.working_time,
      worked_out: @worktime.worked_out,
      balance: @worktime.balance,
      timer_on: object.permissions.exists?(subject: :projects, action: :timer),
      start: @worktime.start_date,
      finish: @worktime.finish_date
    }
  end
end
