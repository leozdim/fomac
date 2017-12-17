class CreateArtActivities < ActiveRecord::Migration[5.1]
  def change
    create_table :art_activities do |t|
      t.references :modality, foreign_key: true
      t.string :name
      t.integer :contributions
      t.string :kind

      t.timestamps
    end
  end
end
