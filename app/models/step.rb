# == Schema Information
#
# Table name: steps
#
#  id          :bigint(8)        not null, primary key
#  name        :string
#  link        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  default     :boolean
#  kind        :string
#  description :string
#

class Step < ApplicationRecord
  has_many :onboarding_steps, dependent: :destroy
  has_many :onboardings, through: :onboarding_steps
  has_many :role_steps, dependent: :destroy
  has_many :roles, through: :role_steps

  KINDS = %w[document tool integration].freeze
  INTEGRATION_TYPES = %w[Discord TimeDoctor].freeze

  validates :name, presence: true
  validates :kind, presence: true, inclusion: KINDS
  validate :integration_type

  def integration_type
    return unless kind == 'integration'
    return if INTEGRATION_TYPES.include?(name)
    errors.add :name, 'Can be only Discord, TimeDoctor'
  end
end
