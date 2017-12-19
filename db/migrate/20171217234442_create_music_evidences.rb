class CreateMusicEvidences < ActiveRecord::Migration[5.1]
  def change
    create_table :music_evidences do |t|
      t.references :project, foreign_key: true
      t.string :web
      t.string :video
      t.string :audio
      t.text :score
      t.text :note
      t.text :document

      t.timestamps
    end
  end
end
