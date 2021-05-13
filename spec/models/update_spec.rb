# == Schema Information
#
# Table name: updates
#
#  id                 :bigint(8)        not null, primary key
#  date               :datetime
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  made               :string
#  planning           :string
#  issues             :string
#  user_id            :integer
#  deleted_at         :datetime
#  slack_ts           :string
#  discord_message_id :string
#
# Indexes
#
#  index_updates_on_deleted_at        (deleted_at)
#  index_updates_on_user_id_and_date  (user_id,date) UNIQUE
#

require 'rails_helper'

RSpec.describe Update, type: :model do
  let(:user) { create :user }
  let(:project) { create :project }
  let(:update) { create :update, user: user }
  let(:update_project) { create :update_project, slack_update: update }
  before do
    update.projects << project
    update.update_projects << update_project
    update.save
  end

  it '#project_ids' do
    expect(Update.project_ids([project.id])).to include(update)
  end

  context '#date_cover validation error' do
    let(:update) { build :update, date: 3.days.ago }

    it '#date_cover' do
      update.valid?
      expect(update.errors[:date]).to include('You cannot save an update for that date.')
    end
  end
end
