class PlanResourceSerializer < ActiveModel::Serializer
  attributes :id, :title, :type

  belongs_to :manager, serializer: UserShortInfoSerializer, if: :project_type?
  attribute :avatar, if: :user_type?
  attribute :paid, if: :project_type?

  def title
    if user_type?
      "#{object.name} #{object.surname}"
    elsif project_type?
      object.title || object.name
    else
      'Unknown resource type'
    end
  end

  def type
    object.class.name.underscore
  end

  def project_type?
    object.is_a? Project
  end

  def user_type?
    object.is_a? User
  end
end
