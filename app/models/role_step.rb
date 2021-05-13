# == Schema Information
#
# Table name: role_steps
#
#  id         :bigint(8)        not null, primary key
#  role_id    :bigint(8)
#  step_id    :bigint(8)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_role_steps_on_role_id  (role_id)
#  index_role_steps_on_step_id  (step_id)
#

class RoleStep < ApplicationRecord
  belongs_to :role
  belongs_to :step
end
