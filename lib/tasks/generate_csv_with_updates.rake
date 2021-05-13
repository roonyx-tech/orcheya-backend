desc 'Generate csv with updates'
task generate_csv_with_updates: :environment do
  require 'csv'

  date_start = Date.parse(ENV['DATE_START']) rescue Date.today.beginning_of_month
  users = User.includes(:updates).where(updates: { date: (date_start..Date.today) })

  file = "#{Rails.root}/public/data.csv"
  CSV.open( file, 'w' ) do |csv|
    csv << [''] + users.map(&:full_name)

    (date_start..Date.today).to_a.reverse.each do |day|
      next unless Update.find_by(date: Time.zone.parse(day.to_s))

      csv << [day.to_s]

      made = ['']
      planning = ['']
      issues = ['']

      users.each do |user|
        update = user.updates.find_by(date: Time.zone.parse(day.to_s))
        made << update&.made || ''
        planning << update&.planning || ''
        issues << update&.issues || ''
      end

      csv << made
      csv << planning
      csv << issues
    end
  end
end
