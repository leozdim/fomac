class CreateLetterEvidences < ActiveRecord::Migration[5.1]
  def change
    create_table :letter_evidences do |t|
      t.references :project, foreign_key: true
      t.string :web
      t.string :work
      t.text :cover

      t.timestamps
    end
  end
end
