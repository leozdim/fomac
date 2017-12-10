class CreateArtForms < ActiveRecord::Migration[5.1]
  def change
    create_table :art_forms do |t|
      t.string :name, null: false
      t.boolean :active, default: true, null: false

      t.timestamps
    end
  end
end
