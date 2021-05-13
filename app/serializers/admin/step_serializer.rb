module Admin
  class StepSerializer < ActiveModel::Serializer
    attributes :id, :name, :link, :kind, :default, :roles

    has_many :roles, serializer: RoleShortSerializer
  end
end
