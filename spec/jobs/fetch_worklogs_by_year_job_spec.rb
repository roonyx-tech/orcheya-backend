require 'rails_helper'

RSpec.describe FetchWorklogsByYearJob, type: :job do
  include ActiveJob::TestHelper

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

  it 'Job running' do
    ActiveJob::Base.queue_adapter = :test

    expect { FetchWorklogsByYearJob.perform_now(user) }
      .to change(ActiveJob::Base.queue_adapter.enqueued_jobs, :size).by(366)
  end
end
