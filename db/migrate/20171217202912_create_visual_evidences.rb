class CreateVisualEvidences < ActiveRecord::Migration[5.1]
  def change
    create_table :visual_evidences do |t|
      t.references :project, foreign_key: true
      t.text :catalog
      t.text :image
      t.text :note
      t.text :document

      t.timestamps
    end
  end
end
