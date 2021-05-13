class SkillUpdateSerializer < ActiveModel::Serializer
  attributes :id, :users_skill_id, :level, :approved, :approver_id, :comment, :updated_at
  belongs_to :user, serializer: UserShortInfoSerializer
end
