class CreateLinks < ActiveRecord::Migration[5.1]
  def up
    create_table :links do |t|
      t.string :link
      t.string :kind
      t.belongs_to :user, index: true
      t.datetime :deleted_at, index: true
      t.timestamps
    end

    User.find_each do |user|
      user.links.create(link: user.github) if user.github.present?
      user.links.create(link: user.bitbucket) if user.bitbucket.present?
    end

    remove_column :users, :github
    remove_column :users, :bitbucket
  end

  def down
    add_column :users, :github, :string
    add_column :users, :bitbucket, :string

    User.find_each do |user|
      gh_link = user.links.find_by(kind: 'github')
      user.update_attribute(:github, gh_link.link) if gh_link
      bb_link = user.links.find_by(kind: 'bitbucket')
      user.update_attribute(:bitbucket, bb_link.link) if bb_link
    end

    drop_table :links
  end
end
