namespace :worklogs do
  desc 'Remove all worklogs and clear user timedoctor'
  task clear: :environment do
    User.all.each do |u|
      u.update timedoctor_token: nil, timedoctor_refresh_token: nil, timedoctor_company_id: nil, timedoctor_user_id: nil
    end
    Worklog.unscoped.delete_all
  end
end
