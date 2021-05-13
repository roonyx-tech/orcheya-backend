require 'rails_helper'

RSpec.describe TimeDoctorService, type: :service do
  let(:user) { create :user }
  let(:user_wl) do
    create :user,
           timedoctor_token: 'ACCESS_TOKEN',
           timedoctor_refresh_token: 'REFRESH_TOKEN',
           timedoctor_user_id: 1,
           timedoctor_company_id: 1
  end
  let(:date) { '2018-04-12' }

  it '.connect', skip: true do
    stub_request(:get, 'https://webapi.timedoctor.com/v1.1/companies' \
                       '?_format=json&access_token=ACCESS_TOKEN')
      .to_return body: JSON.generate(user: { user_id: 1, company_id: 1 })

    stub_request(:get, 'https://webapi.timedoctor.com/oauth/v2/token?_format=json' \
                       "&client_id=#{Rails.application.credentials.timedoctor_client_id}" \
                       "&client_secret=#{Rails.application.credentials.timedoctor_client_secret}"\
                       '&code=code&grant_type=authorization_code' \
                       '&redirect_uri=callback_url')
      .to_return body: JSON.generate(access_token: 'ACCESS_TOKEN', refresh_token: 'REFRESH_TOKEN')

    TimeDoctorService.connect user, 'code', 'callback_url'

    expect(user.timedoctor_token).to eq('ACCESS_TOKEN')
    expect(user.timedoctor_refresh_token).to eq('REFRESH_TOKEN')
    expect(user.timedoctor_user_id).to eq(1)
    expect(user.timedoctor_company_id).to eq(1)
  end

  context 'jira worklogs' do
    it '.fetch_worklogs' do
      stub_request(:get, 'https://webapi.timedoctor.com/v1.1' \
                       "/companies/#{user_wl.timedoctor_company_id}/worklogs" \
                       '?_format=json' \
                       '&access_token=ACCESS_TOKEN' \
                       '&consolidated=0' \
                       "&user_ids=#{user_wl.timedoctor_user_id}" \
                       "&end_date=#{date}&start_date=#{date}")
        .to_return(body: JSON.generate(TimeDoctorStub.worklogs(date)))

      expect { TimeDoctorService.new(user_wl).fetch_worklogs date }
        .to change { Worklog.count }.by 1
    end
  end

  context 'non-jira worklogs' do
    it '.fetch_worklogs' do
      stub_request(:get, 'https://webapi.timedoctor.com/v1.1' \
                       "/companies/#{user_wl.timedoctor_company_id}/worklogs" \
                       '?_format=json' \
                       '&access_token=ACCESS_TOKEN' \
                       '&consolidated=0' \
                       "&user_ids=#{user_wl.timedoctor_user_id}" \
                       "&end_date=#{date}&start_date=#{date}")
        .to_return(body: JSON.generate(TimeDoctorStub.worklogs_non_jira(date)))

      expect { TimeDoctorService.new(user_wl).fetch_worklogs date }
        .to change { Worklog.count }.by 1
    end
  end

  it '.disconnect' do
    TimeDoctorService.new(user_wl).disconnect

    expect(user_wl.timedoctor_token).to be_nil
    expect(user_wl.timedoctor_refresh_token).to be_nil
    expect(user_wl.timedoctor_user_id).to be_nil
    expect(user_wl.timedoctor_company_id).to be_nil
  end
end
