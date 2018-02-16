class CreateSelectedProjects < ActiveRecord::Migration[5.1]
  def change
    create_table :selected_projects do |t|
      t.references :project, foreign_key: true

      t.timestamps
    end
  end
end
