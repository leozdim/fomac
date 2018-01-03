class CreateRevisions < ActiveRecord::Migration[5.1]
  def change
    create_table :revisions do |t|
      t.references :user, foreign_key: true
      t.references :project, foreign_key: true
      t.string :field
      t.string :status
      t.string :observations

      t.timestamps
    end
  end
end
