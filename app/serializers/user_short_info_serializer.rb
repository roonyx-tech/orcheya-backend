class UserShortInfoSerializer < ActiveModel::Serializer
  attributes :id, :name, :surname, :avatar, :title

  def title
    "#{object.name} #{object.surname}"
  end
end
