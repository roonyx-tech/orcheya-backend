module Users
  class TasksService
    attr_reader :user, :date

    class << self
      def by_date(user, date)
        new(user, date).call
      end
    end

    def initialize(user, date)
      @user = user
      @date = date.to_date
    end

    def call
      [].concat(worked_by_worklogs, worked_by_commits).compact.uniq
    end

    def worked_by_worklogs
      user.worklogs
          .where(date: date)
          .select(:task_name, :task_url, :project_id, :source)
          .includes(:project)
          .distinct
          .map { |worklog| Task.new(worklog.slice(:task_name, :task_url, :project_id, :source, :title)) }
    end

    def worked_by_commits
      user.commits
          .where(time: date.beginning_of_day..date.end_of_day)
          .includes(:project)
          .distinct
          .map do |commit|
            Task.new(
              task_name: commit.message,
              task_url: commit.url,
              project_id: commit.project_id,
              source: 'gitlab',
              title: "[#{commit.project_name}] #{commit.message}"
            )
          end
    end

    class Task
      attr_accessor :task_name, :task_url, :project_id, :source, :title

      def initialize(params)
        params.each do |key, value|
          send("#{key}=", value) if respond_to? "#{key}="
        end
      end
    end
  end
end
