class UserSkillsUpdatesSerializer < ActiveModel::Serializer
  attributes :id, :level
  belongs_to :skill, serializer: SkillSerializer
  has_many :skill_last_update, serializer: SkillUpdateSerializer
end
