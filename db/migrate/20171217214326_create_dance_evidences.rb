class CreateDanceEvidences < ActiveRecord::Migration[5.1]
  def change
    create_table :dance_evidences do |t|
      t.references :project, foreign_key: true
      t.string :web
      t.string :video
      t.text :image
      t.text :note
      t.text :document

      t.timestamps
    end
  end
end
