class GitlabService
  attr_reader :params

  class << self
    def create(params)
      new(params).call
    end
  end

  def initialize(params)
    @params = params
  end

  def call
    commits.each do |commit|
      user = find_user(commit)
      next if user.nil?

      Commit.find_or_create_by(uid: commit[:id]) do |new_commit|
        next if commit[:message].start_with?('Merge branch')

        new_commit.assign_attributes(
          message: commit[:message].strip,
          time: commit[:timestamp].to_date,
          url: commit[:url],
          user: user,
          project_name: project_name,
          project: project
        )
      end
    end
  end

  def project_name
    @project_name ||= params.dig(:project, :name)
  end

  def project
    @project ||= Project.where('name = ? or title = ?', project_name, project_name).first
  end

  def commits
    params.require(:commits)
  end

  private

  def find_user(commit)
    find_user_by_email(commit) || find_user_by_name(commit)
  end

  def find_user_by_email(commit)
    User.find_by(email: commit.dig(:author, :email))
  end

  def find_user_by_name(commit)
    full_name = commit.dig(:author, :name)
    return nil if full_name.blank?
    name, surname = full_name.split

    User.find_by(name: name, surname: surname)
  end
end
