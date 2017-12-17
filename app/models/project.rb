class Project < ApplicationRecord
  belongs_to :user
  belongs_to :category
  has_many :people
  has_many :addresses, through: :people
  has_and_belongs_to_many :art_forms
  has_one :information
  has_one :retribution
  accepts_nested_attributes_for :people
  accepts_nested_attributes_for :information
  accepts_nested_attributes_for :retribution

  def single?
    category.single
  end
end
