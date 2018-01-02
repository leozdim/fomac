class CreateTheaterEvidences < ActiveRecord::Migration[5.1]
  def change
    create_table :theater_evidences do |t|
      t.references :project, foreign_key: true
      t.string :web
      t.string :video
      t.string :letter
      t.string :script
      t.text :document
      t.text :image
      t.text :note

      t.timestamps
    end
  end
end
