# == Schema Information
#
# Table name: timings
#
#  id       :bigint(8)        not null, primary key
#  start    :time
#  end      :time
#  flexible :boolean          default(FALSE), not null
#

class Timing < ApplicationRecord
  has_many :users, dependent: :nullify
  validates :start, :end, presence: true, unless: :flexible?

  def from
    return unless start

    time = start.strftime('%H:%M %z')
    date = Date.current
    Time.zone.parse("#{date} #{time}")
  end

  def to
    return unless self.end

    time = self.end.strftime('%H:%M %z')
    date = Date.current
    Time.zone.parse("#{date} #{time}")
  end
end
