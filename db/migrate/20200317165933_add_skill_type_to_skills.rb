class AddSkillTypeToSkills < ActiveRecord::Migration[5.2]
  def change
    add_belongs_to :skills, :skill_type
  end
end
