class WorklogService
  attr_reader :start_date, :end_date

  def initialize(params)
    @start_date = params[:start_date].present? ? params[:start_date].to_date : Date.current
    @end_date = params[:end_date].present? ? params[:end_date].to_date : Date.current
  end

  def self.call(params)
    new(params).data
  end

  def data
    worklogs.load.map do |worklog|
      serialize(worklog)
    end
  end

  private

  def serialize(worklog)
    worklog.as_json(
      include: {
        user: {
          only: %w[id],
          methods: %w[full_name roles]
        },
        project: {
          only: %w[id name paid platform]
        }
      }
    ).merge(
      'total' => total_length_by(worklog.project_id, worklog.task_id, worklog.task_name) * 1000
    )
  end

  def worklogs
    @worklogs = Worklog.where(date: start_date..end_date).includes(:user, :project)
  end

  def total_length_by(project_id, task_id, task_name)
    @total ||= Worklog.group(:project_id, :task_id, :task_name).sum(:length)
    index = [project_id, task_id, task_name]
    @total[index]
  end
end
