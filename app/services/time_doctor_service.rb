class TimeDoctorService
  attr_reader :client
  def self.connect(user, code, callback_uri)
    auth = TimeDoctor::Auth.new(code: code, redirect_uri: callback_uri)
    tokens = auth.fetch_token

    client = TimeDoctor::Client.new(access_token: tokens[:access_token])
    info = client.companies.list

    user.update timedoctor_token: tokens[:access_token],
                timedoctor_refresh_token: tokens[:refresh_token],
                timedoctor_user_id: info[:user][:user_id],
                timedoctor_company_id: info[:user][:company_id],
                temp_integration_token: nil,
                temp_referer: nil
  end

  def initialize(user)
    @user = user
    @client = TimeDoctor::Client.new access_token: user.timedoctor_token,
                                     refresh_token: user.timedoctor_refresh_token,
                                     user: user
  end

  def disconnect
    @user.update timedoctor_token: nil,
                 timedoctor_refresh_token: nil,
                 timedoctor_user_id: nil,
                 timedoctor_company_id: nil
  end

  def fetch_worklogs(day)
    data = @client.worklogs.list company_id: @user.timedoctor_company_id,
                                 user_ids: @user.timedoctor_user_id,
                                 start_date: day, end_date: day,
                                 consolidated: 0

    return if data.nil? || data.dig(:worklogs, :items).nil?
    data[:worklogs][:items].each do |item|
      project = create_project item
      create_worklog item, project, day
    end
  end

  private

  def create_project(item)
    project_id, name = if non_jira_task?(item)
                         [0, 'Non JIRA tasks']
                       else
                         [item[:project_id], item[:project_name]]
                       end

    where = { project_id: project_id, platform: :timedoctor }
    params = { name: name }

    Project.produce(where, params)
  end

  def non_jira_task?(item)
    item[:project_id].blank? || item[:project_name] == 'Non JIRA tasks' ||
      item[:project_id] == '1058217'
  end

  def create_worklog(item, project, date)
    where = { source_id: item[:id] }
    params = {
      length: item[:length],
      task_name: item[:task_name],
      task_url: item[:task_url],
      start_time: item[:start_time],
      end_time: item[:end_time],
      source: :timedoctor,
      user_id: @user.id,
      task_id: item[:task_id],
      project_id: project.id,
      date: date
    }

    Worklog.produce(where, params)
  end
end
