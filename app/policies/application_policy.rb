class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    raise Pundit::NotAuthorizedError, 'Must be signed in.' unless user

    @user = user
    @record = record
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      raise Pundit::NotAuthorizedError, 'must be logged in' unless user

      @user = user
      @scope = scope
    end

    def resolve
      scope.all
    end

    def permissions
      user.permissions || []
    end

    def permission?(action, subject = nil)
      return true if user.email == 'vladimir@roonyx.tech'

      subject = subject ? subject.to_s : self.class.to_s[0..-7]
      user.permissions.exists?(subject: subject.underscore, action: action)
    end
  end

  def permission?(action, subject = nil)
    return true if user.email == 'vladimir@roonyx.tech'

    subject = subject ? subject.to_s : self.class.to_s[0..-7]
    user.permissions.exists?(subject: subject.underscore, action: action)
  end
end
