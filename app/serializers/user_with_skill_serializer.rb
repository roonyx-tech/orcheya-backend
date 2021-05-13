class UserWithSkillSerializer < UserShortInfoSerializer
  attribute :english_level
  has_many :users_skills
  has_many :roles
end
