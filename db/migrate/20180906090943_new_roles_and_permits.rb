class NewRolesAndPermits < ActiveRecord::Migration[5.1]
  def up
    drop_table :abilities
    drop_table :permits

    create_table :permits, id: :string do |t|
      t.string :title
      t.text :description
    end

    Permit.reset_column_information

    Rake::Task['permits:load'].invoke

    create_table :permits_roles do |t|
      t.string :permit_id, index: true
      t.belongs_to :role, index: true
    end

    create_table :roles_users do |t|
      t.belongs_to :role, index: true
      t.belongs_to :user, index: true
    end

    Role.find_each do |role|
      role.permits << Permit.find_by(id: 'superadmin') if %w[CTO COO].include?(role.name)
      role.permits << Permit.find_by(id: 'role_admin') if role.is_admin
      role.permits << Permit.find_by(id: 'role_developer') if role.is_developer
      role.permits << Permit.find_by(id: 'birthday_notify') if role.is_birthday_notify
      role.permits << Permit.find_by(id: 'inventory_management') if role.is_inventory_notify
    end

    remove_column :roles, :is_admin
    remove_column :roles, :is_developer
    remove_column :roles, :is_birthday_notify
    remove_column :roles, :is_inventory_notify

    User.unscoped.find_each do |user|
      user.roles << Role.find_by(id: user.role_id) unless user.role_id.nil?
    end

    remove_column :users, :role_id
  end

  def down
    add_column :users, :role_id, :integer
    add_index :users, :role_id

    User.unscoped.find_each do |user|
      user.update(role_id: user.roles.first.id) unless user.roles.count.zero?
    end

    add_column :roles, :is_admin, :boolean
    add_column :roles, :is_developer, :boolean
    add_column :roles, :is_birthday_notify, :boolean
    add_column :roles, :is_inventory_notify, :boolean

    Role.reset_column_information

    Role.find_each do |role|
      role.is_admin = true if role.permits.find_by(id: 'role_admin')
      role.is_developer = true if role.permits.find_by(id: 'role_developer')
      role.is_birthday_notify = true if role.permits.find_by(id: 'birthday_notify')
      role.is_inventory_notify = true if role.permits.find_by(id: 'inventory_management')
      role.save
    end

    drop_table :permits_roles
    drop_table :roles_users
    drop_table :permits

    create_table :abilities, id: :string do |t|
      t.string :title
      t.text :description
    end

    create_table :permits do |t|
      t.integer :user_id
      t.string :ability_id
    end

    add_index :permits, [:user_id, :ability_id], unique: true
  end
end
