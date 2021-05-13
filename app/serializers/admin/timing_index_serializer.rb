module Admin
  class TimingIndexSerializer < ActiveModel::Serializer
    attributes :id, :from, :to, :flexible, :users_count

    def users_count
      object.users.count
    end
  end
end
