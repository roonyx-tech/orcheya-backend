# == Schema Information
#
# Table name: updates
#
#  id                 :bigint(8)        not null, primary key
#  date               :datetime
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  made               :string
#  planning           :string
#  issues             :string
#  user_id            :integer
#  deleted_at         :datetime
#  slack_ts           :string
#  discord_message_id :string
#
# Indexes
#
#  index_updates_on_deleted_at        (deleted_at)
#  index_updates_on_user_id_and_date  (user_id,date) UNIQUE
#

class UpdateSerializer < ActiveModel::Serializer
  attributes :id,
             :date,
             :made,
             :planning,
             :issues,
             :created_at
  belongs_to :user
  has_many :projects, through: :update_projects
end
