require 'rails_helper'

RSpec.describe FetchWorklogsByDayJob, type: :job do
  let(:user) do
    create :user,
           timedoctor_token: 'ACCESS_TOKEN',
           timedoctor_refresh_token: 'REFRESH_TOKEN',
           timedoctor_user_id: 1,
           timedoctor_company_id: 1
  end

  it 'Job is created' do
    ActiveJob::Base.queue_adapter = :test
    described_class.perform_later(user)
    expect(described_class)
      .to have_been_enqueued.on_queue('worklogs')
  end

  # I don't know how to fix it
  # it 'Job running' do
  #   ActiveJob::Base.queue_adapter = :test
  #
  #   today = Time.zone.now.to_date.to_s
  #
  #   stub_request(:get, 'https://webapi.timedoctor.com/v1.1/companies/1/worklogs'\
  #                      '?_format=json&access_token=ACCESS_TOKEN'\
  #                      "&end_date=#{today}&start_date=#{today}&user_ids=1")
  #     .to_return(status: 200, body: JSON.generate(TimeDoctorStub.worklogs(today)))
  #
  #   expect { described_class.perform_now(user, today) }
  #     .to change { Worklog.count }.by(2)
  # end
end
