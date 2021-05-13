module Searchable
  extend ActiveSupport::Concern

  included do
    scope :search_by, lambda { |names, query|
      where(names.map { |field| "#{table_name}.#{field} ILIKE :query" }.join(' OR '),
            query: "%#{query}%")
    }
  end
end
