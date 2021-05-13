Rake::Task['permissions:load'].invoke
Rake::Task['difficulty_levels:load'].invoke

Timing.create(start: '08:00 +0300', end: '17:00 +0300')
Timing.create(start: '09:00 +0300', end: '18:00 +0300')
Timing.create(start: '10:00 +0300', end: '19:00 +0300')
Timing.create(start: '11:00 +0300', end: '20:00 +0300')

unless Rails.env.test?
  PROJECTS = ['AI, Computer Vision', 'Human Velocity', 'My Kitchen', 'Royality',
              'Tender CRM', 'Projects For Good', 'ICO Mint', 'DidItFor', 'FAW',
              'Enbi', 'CRM Dealer Point', 'AI, NLP', 'AI, predictive system'].freeze
  TAGS = ['Part Time', 'Low Rate'].freeze

  FileUtils.rm_rf(Dir[Rails.root.join('public', 'uploads')])

  FactoryBot.create :admin, :invite_accepted

  if Rails.env.demo?
    FactoryBot.create(:admin, :invite_accepted, email: 'demo@roonyx.tech', name: 'Demo', surname: 'User')
  end

  FactoryBot.create_list :role, 5, :with_permissions

  users = FactoryBot.create_list :user, 30, :invite_accepted, :with_role

  PROJECTS.each do |project|
    FactoryBot.create :project, name: project
  end

  FactoryBot.create_list :report, 15

  users.each do |user|
    30.times do |t|
      next if t.days.ago.on_weekend?

      update = FactoryBot.build :update, user: user, date: t.days.ago.change(hour: (19..23).to_a.sample,
                                                                             min: (10..59).to_a.sample)
      update.save(validate: false)
      update
    end
    99.times do |t|
      next if (t / 3).days.ago.on_weekend?

      FactoryBot.create :worklog, user: user, date: (t / 3).days.ago
    end
  end

  FactoryBot.create_list :update_project, 150
  FactoryBot.create_list :link, 150
  FactoryBot.create_list :event, 40
  FactoryBot.create_list :project_event, 20

  users.sample(5).each do |user|
    FactoryBot.create :vacation_event, user: user
  end

  DifficultyLevel.all.each do |difficulty|
    skills = FactoryBot.create_list :skill, rand(1..3), difficulty_level_id: difficulty.id
    skills.each do |skill|
      users.sample(10).each { |user| FactoryBot.create :users_skill, :approved, skill: skill, user: user }
    end
  end
end
