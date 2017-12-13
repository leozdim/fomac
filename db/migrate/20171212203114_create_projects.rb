class CreateProjects < ActiveRecord::Migration[5.1]
  def change
    create_table :projects do |t|
      t.string :folio
      t.references :user, foreign_key: true
      t.references :category, foreign_key: true
      t.string :status

      t.timestamps
    end
  end
end
