# == Schema Information
#
# Table name: onboardings
#
#  id                   :bigint(8)        not null, primary key
#  gmail_login          :string
#  gmail_password       :string
#  user_id              :bigint(8)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  invitation_url       :string
#  raw_invitation_token :string
#
# Indexes
#
#  index_onboardings_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#

class Onboarding < ApplicationRecord
  belongs_to :user
  has_many :onboarding_steps, dependent: :destroy
  has_many :steps, through: :onboarding_steps

  accepts_nested_attributes_for :steps
  accepts_nested_attributes_for :onboarding_steps

  validates :gmail_login, :gmail_password, presence: true

  after_create :generate_invitation_link

  private

  def generate_invitation_link
    update(
      raw_invitation_token: user.raw_invitation_token,
      invitation_url: Rails.application.credentials.frontend_url + '/invitation/' + user.raw_invitation_token
    )
  end
end
