# == Schema Information
#
# Table name: links
#
#  id         :bigint(8)        not null, primary key
#  link       :string
#  kind       :string
#  user_id    :bigint(8)
#  deleted_at :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_links_on_deleted_at  (deleted_at)
#  index_links_on_user_id     (user_id)
#

require 'rails_helper'

RSpec.describe Link, type: :model do
  let!(:link) { build :link, link: '' }

  it '#valid_url' do
    link.valid?
    expect(link.errors[:link]).to include('Invalid link')
  end
end
