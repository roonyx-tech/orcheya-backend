class CreateAbilities < ActiveRecord::Migration[5.1]
  def change
    create_table :abilities, id: :string do |t|
      t.string :title
      t.text :description
    end
  end
end
