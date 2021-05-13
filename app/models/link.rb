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

class Link < ApplicationRecord
  acts_as_paranoid

  belongs_to :user
  before_validation :check_url_name
  validate :valid_url

  private

  def check_url_name
    self.kind = URI(link).host
    self.kind ||= URI("http://#{link}").host
    self.kind = kind.try(:split, '.').try(:[], -2)
  end

  def valid_url
    return if kind.present?
    errors.add(:link, 'Invalid link')
  end
end
