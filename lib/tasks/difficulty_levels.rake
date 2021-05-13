namespace :difficulty_levels do
  desc 'Load difficulty levels to db'
  task load: :environment do
    file = Rails.root.join('db', 'difficulty_levels.yml')
    data = YAML.load_file(file).deep_symbolize_keys
    dif_levels = data[:difficulty_levels] || []

    on_db = DifficultyLevel.all

    on_file = dif_levels.map do |dif_level|
      where = { title: dif_level.fetch(:title) }
      DifficultyLevel.produce(where, dif_level)
    end

    deleted = on_db - on_file

    DifficultyLevel.destroy deleted.map(&:id)
  end
end
