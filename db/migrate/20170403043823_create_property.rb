class CreateProperty < ActiveRecord::Migration[5.0]
  def change
    create_table(:properties) do |t|
      t.integer :x, null: false
      t.integer :y, null: false
      t.string :title, null: false
      t.float :price, null: false
      t.string :description, null: false
      t.integer :beds, null: false
      t.integer :baths, null: false
      t.integer :square_meters, null: false

      t.timestamps null: false
    end
  end
end
