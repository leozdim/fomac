class Project < ApplicationRecord
  belongs_to :user
  belongs_to :category
  has_many :people
  has_many :addresses, through: :people
  has_many :person_document , through: :people
  has_and_belongs_to_many :art_forms
  has_one :information
  has_one :retribution
  has_one :visual_evidence
  has_one :music_evidence
  has_one :dance_evidence
  has_one :theater_evidence
  has_one :film_evidence
  has_one :letter_evidence
  accepts_nested_attributes_for :people
  accepts_nested_attributes_for :information
  accepts_nested_attributes_for :retribution
  accepts_nested_attributes_for :visual_evidence
  accepts_nested_attributes_for :dance_evidence
  accepts_nested_attributes_for :music_evidence
  accepts_nested_attributes_for :theater_evidence
  accepts_nested_attributes_for :film_evidence
  accepts_nested_attributes_for :letter_evidence
  validates_presence_of :category, :art_forms

  def single?
    category.single
  end

  def any_evidence?
    if visual_evidence.nil? and dance_evidence.nil? and music_evidence.nil? and theater_evidence.nil? and film_evidence.nil? and letter_evidence.nil? 
      false
    else
      true
    end
  end

end
