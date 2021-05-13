module Admin
  class AchievementSerializer < ActiveModel::Serializer
    attributes :id, :title, :kind, :image, :levels, :endpoint, :roles, :users, :levels

    has_many :roles, serializer: RoleShortSerializer
    has_many :users, serializer: UserShortestSerializer
    has_many :levels, serializer: AchievementLevelSerializer
  end
end
