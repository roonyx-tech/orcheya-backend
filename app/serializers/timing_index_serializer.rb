class TimingIndexSerializer < ActiveModel::Serializer
  attributes :id, :from, :to, :flexible
end
