class TimeDoctorStub
  def self.worklogs(date) # rubocop:disable MethodLength
    {
      start_time: "#{date} 00:00:00",
      end_time: "#{date} 23:59:59",
      total: 24_962,
      url: 'https://webapi.timedoctor.com/v1.1/companies/' \
           '587525/worklogs?start_date=2018-04-12' \
           '&end_date=2018-04-12&offset=0&limit=500'\
           '&user_ids=1188995&consolidated=0&breaks_only=0',
      worklogs: {
        count: 2, url: '', offset: 0, limit: 500,
        items: [
          {
            length: '13046',
            user_id: '1',
            user_name: 'Dev',
            task_id: '36863607',
            task_name: 'Task 1',
            task_url: 'Task url 1',
            project_id: '1352111',
            project_name: 'Orcheya'
          }
        ]
      }
    }
  end

  def self.worklogs_non_jira(date) # rubocop:disable MethodLength
    {
      start_time: "#{date} 00:00:00",
      end_time: "#{date} 23:59:59",
      total: 24_962,
      url: 'https://webapi.timedoctor.com/v1.1/companies/' \
           '587525/worklogs?start_date=2018-04-12' \
           '&end_date=2018-04-12&offset=0&limit=500'\
           '&user_ids=1188995&consolidated=0&breaks_only=0',
      worklogs: {
        count: 2, url: '', offset: 0, limit: 500,
        items: [
          {
            length: '11916',
            user_id: '1',
            user_name: 'Dev Middle',
            task_id: '36873935',
            task_name: 'Task 1',
            task_url: 'Task url 1',
            project_id: '1352111',
            project_name: 'Non JIRA tasks'
          }
        ]
      }
    }
  end

  def self.companies # rubocop:disable MethodLength
    {
      user: {
        full_name: 'Name Surname',
        first_name: 'Name Surname',
        last_name: '',
        email: 'email@example.com',
        url: 'https://webapi.timedoctor.com/v1.1/companies/587525/users/1',
        user_id: 1,
        company_id: 587_525,
        level: 'user',
        projects: nil,
        tasks: nil,
        work_status: nil,
        managed_users: nil,
        teams: nil,
        payroll_access: 0,
        billing_access: false,
        avatar: 'https://s3.amazonaws.com/avatars/small_avatar.png',
        screenshots_active: '1',
        manual_time: '0',
        permanent_tasks: 0,
        computer_time_popup: '540',
        poor_time_popup: '1',
        blur_screenshots: 0,
        web_and_app_monitoring: '1',
        webcam_shots: 0,
        screenshots_interval: '9',
        user_role_value: nil,
        status: 'active',
        reports_hidden: nil
      },
      accounts: [
        {
          user_id: 1_188_995,
          company_id: 587_525,
          type: 'user',
          company_name: 'Roonyx',
          url: 'https://webapi.timedoctor.com/v1.1/companies/587525/users/1188995',
          company_time_zone_id: 41,
          company_subdomain: 'roonyx',
          company_logo: 'https://s3.amazonaws.com/tds3_avatars/587525_logo.jpg'
        }
      ]
    }
  end
end
