desc 'Update fired users'
task update_fired_users: :environment do
  [
    [25, 'Дмитрий Аникин',       '01.11.2014', ''],
    [30, 'Дмитрий Яшметов',      '30.05.2015', ''],
    [12, 'Марина Захарова',      '07.11.2017', ''],
    [24, 'Андрей Кулешов',       '15.02.2017', ''],
    [38, 'Марк Гладков',         '22.12.2017', ''],
    [28, 'Александр Дюмин',      '15.07.2016', ''],
    [10, 'Евгений Яковчук',      '15.01.2018', ''],
    [36, 'Эдуард Ендовицкий',    '17.06.2017', ''],
    [20, 'Алексей Джиквас',      '13.12.2013', ''],
    [22, 'Александр Светличный', '01.08.2017', ''],
    [8,  'Прохор Волощенко',     '19.03.2018', ''],
    [35, 'Денис Остер',          '21.12.2017', ''],
    [40, 'Андрей Вогулкин',      '02.07.2018', ''],
    [42, 'Алексей Ермолаев',     '02.07.2018', ''],
    [41, 'Андрей Новоселов',     '02.07.2018', ''],

    [21, 'Александр Корчагин',   '18.08.2017', '16.07.2018'],
    [17, 'Олег Бабенко',         '01.08.2016', '06.07.2018'],
    [5,  'Игорь Каспаров',       '30.03.2015', '06.07.2018'],
    # [xx, 'Саид Гамидинов',       '27.06.2017', '21.03.2018'],
    # [xx, 'Владимир Трубачев',    '01.09.2014', '30.03.2018'],
    # [xx, 'Анастасия Мащенко',    '15.07.2017', '23.03.2018'],
    # [xx, 'Сергей Репин',         '06.03.2018', '06.04.2018'],
  ].each do |user_data|
    if user = User.with_deleted.find(user_data[0])
      user.update! created_at: user_data[2],
                   updated_at: user_data[2],
                   deleted_at: (user_data[3] || nil)
    end
  end
end

desc 'Fix svetly date typo'
task fix_svetly_date: :environment do
  User.find(22).update! created_at: '01.08.2017'
end
