class CreateRetributions < ActiveRecord::Migration[5.1]
  def change
    create_table :retributions do |t|
      t.references :project, foreign_key: true
      t.references :modality, foreign_key: true
      t.references :art_activity, foreign_key: true
      t.text :description

      t.timestamps
    end
  end
end
