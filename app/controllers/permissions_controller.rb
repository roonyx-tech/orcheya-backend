class PermissionsController < ApplicationController
  def index
    subjects = PermissionSubject.includes(:permissions)
    render json: subjects
  end
end
