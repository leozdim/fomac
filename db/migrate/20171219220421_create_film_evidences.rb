class CreateFilmEvidences < ActiveRecord::Migration[5.1]
  def change
    create_table :film_evidences do |t|
      t.references :project, foreign_key: true
      t.string :web
      t.string :video
      t.string :demo
      t.string :synopsis
      t.string :script
      t.string :plan
      t.string :letter

      t.timestamps
    end
  end
end
