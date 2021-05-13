class ChangeEnglishLevels < ActiveRecord::Migration[6.0]
  def up
    User.where('english_level > ?', 3).each do |user|
      user.update(english_level: user.english_level + 1)
    end
  end

  def down
    User.where('english_level > ?', 4).each do |user|
      user.update(english_level: user.english_level - 1)
    end
  end
end
