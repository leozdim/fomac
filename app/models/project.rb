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
  has_many :revisions
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

  def folio
    first= category.key 
    second= art_forms.first.name if art_forms.length==1 
    third= id
    "#{first} #{second} #{third}".parameterize
  end 

  def self.find_by_folio folio
    id=folio.split('-').last 
    find_by id: id
  end

  def revision_model
    revisions.where(status: 'Invalido')
  end

  def revisions_persondoc
    revisions.where(status: 'Invalido', model: 'person_documents')
  end

  #CAUTION valid is a method of active record  
  def is_valid?
    revisions.where(status: 'Valido').count == 22
  end

  def invalid_revisions_person_documents
    revisions.where(status: 'Invalido', model: 'person_documents')
  end

  def invalid_revisions
    revisions.where(status: 'Invalido')
  end

  def finish?
    if people.any? and person_document.any? and !information.blank? and !retribution.blank?
      evi=false
      art_forms.each do |a|
        case a.id 
        when 1
          evi=!visual_evidence.blank?
        when 2
          evi=!dance_evidence.blank?
        when 3
          evi=!music_evidence.blank?
        when 4
          evi=!theater_evidence.blank?
        when 5
          evi=!film_evidence.blank?
        when 6
          evi=!letter_evidence.blank?
        end
      end
      return evi
    end
    false
  end

end
