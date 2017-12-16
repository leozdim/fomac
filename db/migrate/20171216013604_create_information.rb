class CreateInformation < ActiveRecord::Migration[5.1]
  def change
    create_table :information do |t|
      t.references :project, foreign_key: true
      t.string :name
      t.text :description
      t.text :antecedent
      t.text :justification
      t.text :general_objective
      t.text :specific_objective
      t.text :goals
      t.text :beneficiary
      t.text :context
      t.text :bibliography
      t.string :activities
      t.string :spending
      t.string :funding

      t.timestamps
    end
  end
end     

