class Person < ApplicationRecord
  has_many :addresses
  belongs_to :project
  has_one :user
  accepts_nested_attributes_for :addresses
  has_one :person_document
  accepts_nested_attributes_for :person_document,allow_destroy: true

  def birthdate=(new_status)
    date=Date.parse new_status.values.join("-")
    write_attribute :birthdate, date
  end
end
