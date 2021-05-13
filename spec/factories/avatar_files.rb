FactoryBot.define do
  sequence :avatar_file_man do |n|
    n %= 20
    Rails.root.join('public', 'images', 'persons', "man_person_#{n}.jpg")
  end

  sequence :avatar_file_woman do |n|
    n %= 20
    Rails.root.join('public', 'images', 'persons', "woman_person_#{n}.jpg")
  end
end
