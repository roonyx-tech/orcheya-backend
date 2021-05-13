class EventPolicy < ApplicationPolicy
  def permitted_attributes
    attributes = %i[title description started_at ended_at all_day type tag]
    attributes.concat(%i[status user_id]) if manage_all?
    attributes.concat(%i[project_id user_id]) if manage_projects?
    attributes.uniq
  end

  def show?
    permission?(:vacation, :calendar)
  end

  def manage_all?
    permission?(:manage_all, :calendar)
  end

  def manage_holidays?
    permission?(:holidays, :calendar)
  end

  def manage_projects?
    permission?(:planning, :projects)
  end

  def owner?
    record.user_id == user.id
  end

  def not_too_old?
    record.started_at && (record.started_at > 3.days.ago)
  end
end
