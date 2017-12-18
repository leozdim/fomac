class Project < ApplicationRecord
  belongs_to :user
  belongs_to :category
  has_many :people
  has_many :addresses, through: :people
  has_and_belongs_to_many :art_forms
  has_one :information
  has_one :retribution
  has_one :visual_evidence
  has_one :music_evidence
  has_one :dance_evidence
  accepts_nested_attributes_for :people
  accepts_nested_attributes_for :information
  accepts_nested_attributes_for :retribution
  accepts_nested_attributes_for :visual_evidence
  accepts_nested_attributes_for :dance_evidence
  accepts_nested_attributes_for :music_evidence

  def single?
    category.single
  end
end
