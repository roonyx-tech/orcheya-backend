require 'rails_helper'

RSpec.describe SlackService, type: :service do
  let(:user) { create :user, slack_id: nil, slack_token: nil }
  let(:slack_data) { { user_id: SecureRandom.hex(6), access_token: SecureRandom.hex(6) } }

  let!(:user_info_stub) do
    stub_request(:post, 'https://slack.com/api/users.info')
      .to_return(body: JSON.generate(
        ok: true,
        user: {
          id: 'W012A3CDE',
          team_id: 'T012AB3C4',
          name: 'spengler',
          deleted: false,
          color: '9f69e7',
          real_name: 'Egon Spengler',
          tz: 'America/Los_Angeles',
          tz_label: 'Pacific Daylight Time',
          tz_offset: -25_200,
          profile: {
            avatar_hash: 'ge3b51ca72de',
            status_text: 'Print is dead',
            status_emoji: ':books:',
            real_name: 'Egon Spengler',
            display_name: 'spengler',
            real_name_normalized: 'Egon Spengler',
            display_name_normalized: 'spengler',
            email: 'spengler@ghostbusters.example.com',
            team: 'T012AB3C4'
          },
          is_admin: true,
          is_owner: false,
          is_primary_owner: false,
          is_restricted: false,
          is_ultra_restricted: false,
          is_bot: false,
          updated: 1_502_138_686,
          is_app_user: false,
          has_2fa: false
        }
      ))
  end

  it 'connect' do
    SlackService.connect user, slack_data

    expect(user.slack_id).to eq(slack_data[:user_id])
    expect(user.slack_token).to eq(slack_data[:access_token])
    expect(user.slack_team_id).to eq(slack_data[:team_id])
    expect(user.slack_name).to eq('Egon Spengler')
    expect(user.temp_integration_token).to be_nil
    expect(user.temp_referer).to be_nil
  end

  it 'disconnect' do
    SlackService.disconnect user

    expect(user.slack_id).to be_nil
    expect(user.slack_token).to be_nil
    expect(user.slack_team_id).to be_nil
    expect(user.slack_name).to be_nil
  end
end
