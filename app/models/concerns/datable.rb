module Datable
  extend ActiveSupport::Concern

  module ClassMethods
    def from(date)
      from = date.to_date.beginning_of_day
      where('date >= ?', from)
    end

    def to(date)
      to = date.to_date.end_of_day
      where('date <= ?', to)
    end

    def at(from, to = nil)
      from = from.to_date.beginning_of_day
      to = to.nil? ? from.to_date.end_of_day : to.to_date.end_of_day
      from(from).to(to)
    end
  end
end
