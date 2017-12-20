class CreatePersonDocuments < ActiveRecord::Migration[5.1]
  def change
    create_table :person_documents do |t|
      t.references :person, foreign_key: true , index: {:name => 'person_index'}
      t.string :request_letter
      t.string :birth
      t.string :address
      t.string :identification
      t.string :curp
      t.string :resume
      t.string :kardex
      t.string :agreement_letter
      t.string :assign_letter
      t.timestamps
    end
  end
end
