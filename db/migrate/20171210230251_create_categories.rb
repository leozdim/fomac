class CreateCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :categories do |t|
      t.string :name, null: false
      t.string :key, null: false
      t.boolean :single, null: false
      t.boolean :active, default: true, null: false

      t.timestamps
    end
  end
end
