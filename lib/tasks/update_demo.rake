namespace :update_demo do
  desc "Create updates"
  task updates: :environment do
    User.all.each do |user|
      7.times do |t|
        next if Update.all.where(user_id: user.id, date: t.days.ago.all_day).present? || t.days.ago.on_weekend?

        update = FactoryBot.build :update, user: user,
                                  date: t.days.ago.change(hour: (19..23).to_a.sample, min: (10..59).to_a.sample)
        update.save(validate: false)
        update

        FactoryBot.create :worklog, user: user, date: t.days.ago,
                          length: Faker::Number.between(from: 20_000, to: 36_000)
      end
    end
  end

  desc "Refresh events"
  task events: :environment do
    Event.delete_all
    FactoryBot.create_list :event, 40
    FactoryBot.create_list :project_event, 20
    User.all.sample(5).each do |user|
      FactoryBot.create :vacation_event, user: user
    end
  end

  desc "Update demo"
  task run: :environment do
    next unless Rails.env.demo?

    Rake::Task['update_demo:updates'].invoke
    Rake::Task['update_demo:events'].invoke
  end
end
