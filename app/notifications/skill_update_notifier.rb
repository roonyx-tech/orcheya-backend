class SkillUpdateNotifier < BaseNotifier
  include Rails.application.routes.url_helpers
  Rails.application.routes.default_url_options = ActionMailer::Base.default_url_options

  def initialize(users_skill)
    @skills = users_skill.map(&:skill).map(&:title)
    @user = users_skill.first.user
  end

  def notify_skill_update
    text = "#{@user.name} #{@user.surname} поменял уровень следующих скиллов: #{@skills.join(', ')}.
            Перейдите по https://orcheya.com/user-profile/#{@user.id}?tab=skills"

    Permission.users_by('notifications:skills_update').each do |user|
      notify(action: :notify_skill_update, recipient: user, template: text)
    end
  end
end
