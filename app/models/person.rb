class Person < ApplicationRecord
  has_many :addresses
  belongs_to :project
  has_one :user
  accepts_nested_attributes_for :addresses
end
