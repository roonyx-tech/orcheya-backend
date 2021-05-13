namespace :permissions do
  desc 'Setup permissions'
  task load: :environment do
    next unless ActiveRecord::Base.connection.table_exists?('permission_subjects')
    puts 'Permissions:' unless Rails.env.test?
    permissions_ids = []
    permission_subject_ids = []
    path = Rails.root.join('config', 'permissions.yml')
    permissions = HashWithIndifferentAccess.new(YAML.safe_load(File.read(path)))
    permissions.each do |subject, params|
      permission_subject = PermissionSubject.find_or_initialize_by(name: subject)
      permission_subject.update_attributes({
        title: params[:title] || 'Undefined .title',
        description: params[:description] || 'Undefined .description',
      })
      permission_subject_ids << permission_subject.id
      params[:actions].each do |action, description|
        permission = Permission.find_or_initialize_by(subject: subject.to_s, action: action)
        permission.update_attributes(description: description)
        permissions_ids << permission.id
        puts "     #{subject}:#{action} - ID #{permission.id}" unless Rails.env.test?
      end
    end
    Permission.where.not(id: permissions_ids).destroy_all
    PermissionSubject.where.not(id: permission_subject_ids).destroy_all
  end
end
