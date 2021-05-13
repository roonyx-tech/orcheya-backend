namespace :achievements do
  desc 'Set score for all users achievements'
  task set_score: :environment do
    Achievement.where(kind: 'auto').each do |achievement|
      new_users = achievement.roles.map(&:users).flatten - achievement.users
      achievement.users << new_users
    end

    Achievement.where(kind: 'auto').each do |achievement|
      achievement.users_achievements.each(&:set_score)
    end
  end
end
