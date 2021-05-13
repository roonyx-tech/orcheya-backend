# == Schema Information
#
# Table name: roles
#
#  id   :bigint(8)        not null, primary key
#  name :string           not null
#

FactoryBot.define do
  factory :role do
    name { Faker::Job.title }

    trait :with_permissions do
      permissions { Permission.all.sample(5) }
    end
  end

  factory :admin_role, parent: :role do
    name { 'Admin' }
    permissions { Permission.all }
  end
end
