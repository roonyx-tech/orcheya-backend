class CreateCoins < ActiveRecord::Migration[5.1]
  def up
    create_table :coins do |t|
      t.belongs_to :user, index: true
      t.text :comment
      t.integer :way
      t.float :value
      t.float :coins
      t.references :relation, polymorphic: true, index: true
      t.datetime :deleted_at, index: true
      t.timestamps
    end

    User.unscoped.find_each do |user|
      user.coins.create!(
        comment: 'Your wallet was created',
        way: :income,
        value: 0,
        coins: 0
      )
    end
  end

  def down
    drop_table :coins
  end
end
