class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.random
    offset = rand(count)
    self.offset(offset).first
  end

  def self.produce(where, update = {})
    record = self.where(where).first_or_initialize
    record.update!(update)
    record
  end
end
