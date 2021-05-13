# == Schema Information
#
# Table name: permissions
#
#  id          :bigint(8)        not null, primary key
#  subject     :string
#  action      :string
#  description :string
#

require 'rails_helper'

RSpec.describe Update, type: :model do
  let(:permission) { create :permission }

  it '#title' do
    expect(permission.title).to eql("#{permission.subject}: #{permission.action}")
  end
end
