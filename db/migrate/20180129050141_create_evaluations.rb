class CreateEvaluations < ActiveRecord::Migration[5.1]
  def change
    create_table :evaluations do |t|
      t.references :project_assignment, foreign_key: true
      t.string :justification_text
      t.integer :justification_value
      t.string :clarity_text
      t.integer :clarity_value
      t.string :timeframe_text
      t.integer :timeframe_value
      t.string :schema_text
      t.integer :schema_value
      t.string :excellence_text
      t.integer :excellence_value
      t.string :creativity_text
      t.integer :creativity_value
      t.string :originality_text
      t.integer :originality_value
      t.string :innovation_text
      t.integer :innovation_value
      t.string :innovation_text
      t.integer :innovation_value
      t.string :feasibility_text
      t.integer :feasibility_value
      t.string :impact_text
      t.integer :impact_value

      t.timestamps
    end
  end
end
