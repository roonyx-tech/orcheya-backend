# == Schema Information
#
# Table name: projects
#
#  id         :bigint(8)        not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  project_id :integer
#  paid       :boolean          default(FALSE), not null
#  platform   :integer
#  manager_id :bigint(8)
#  archived   :boolean          default(FALSE), not null
#  title      :string
#
# Indexes
#
#  index_projects_on_manager_id  (manager_id)
#  index_projects_on_project_id  (project_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (manager_id => users.id)
#

class Project < ApplicationRecord
  include Searchable

  belongs_to :manager, class_name: 'User', optional: true
  has_many :worklogs, -> { with_deleted }, inverse_of: :project, dependent: :nullify
  has_many :update_projects, dependent: :restrict_with_exception
  has_many :slack_update, through: :update_projects
  has_many :reports, dependent: :destroy
  has_many :events, dependent: :destroy
  has_many :users, -> { distinct }, through: :events

  validates :name, presence: true

  before_validation :normalize, if: :inner?

  enum platform: %w[inner timedoctor]

  scope :for_ids_with_order, lambda { |ids|
    order = sanitize_sql_array(
      ['position(id::text in ?)', ids.join(',')]
    )
    where(id: ids).order(order)
  }
  scope :search_by_name, ->(query) { search_by(%w[name title], query) }
  scope :active, -> { where(archived: false) }
  scope :paid, -> { where(paid: true) }

  def normalize
    self.name = title
    self.paid = false if paid.nil?
    self.archived = false if archived.nil?
  end
end
