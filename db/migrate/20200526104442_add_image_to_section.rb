class AddImageToSection < ActiveRecord::Migration[6.0]
  def change
    add_column :sections, :image, :string
  end
end
