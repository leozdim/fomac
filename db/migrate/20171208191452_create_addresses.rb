class CreateAddresses < ActiveRecord::Migration[5.1]
  def change
    create_table :addresses do |t|
      t.references :person, foreign_key: true
      t.string :street
      t.string :internal_number
      t.string :external_number
      t.string :colony
      t.string :zip

      t.timestamps
    end
  end
end
