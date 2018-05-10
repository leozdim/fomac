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
  has_many :reports
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
    revisions.where(status: 'Invalido', model: 'person_document')
  end

  def revisions_film_evidence
    revisions.where(status: 'Invalido', model: 'film_evidence')
  end
  def revisions_visual_evidence
    revisions.where(status: 'Invalido', model: 'visual_evidence')
  end
  def revisions_dance_evidence
    revisions.where(status: 'Invalido', model: 'dance_evidence')
  end
  def revisions_letter_evidence
    revisions.where(status: 'Invalido', model: 'letter_evidence')
  end
  def revisions_theater_evidence
    revisions.where(status: 'Invalido', model: 'theater_evidence')
  end
  def revisions_music_evidence
    revisions.where(status: 'Invalido', model: 'music_evidence')
  end

  def revisions_information
    revisions.where(status: 'Invalido', model: 'information')
  end

  def getfieldscount
    sum = 22
    dance_= 5
    film = 8
    letter= 3
    music= 6
    theater= 7
    visual= 4
    sum +=  !visual_evidence.blank? ? visual: 0
    sum +=  !film_evidence.blank? ? film: 0
    sum +=  !dance_evidence.blank? ? dance_: 0
    sum +=  !letter_evidence.blank? ? letter: 0
    sum +=  !music_evidence.blank? ? music: 0
    sum +=  !theater_evidence.blank? ? theater: 0
    return sum
  end

  #CAUTION valid is a method of active record  
  def is_valid?
    revisions.where(status: 'Valido').count == getfieldscount
    # return false
  end

  def invalid_revisions_person_documents
    revisions.where(status: 'Invalido', model: 'person_document')
  end

  def invalid_revisions_evidence
    revisions.where(status: 'Invalido', :model=>[ 'visual_evidence','dance_evidence',
                                                  'music_evidence','theater_evidence',
                                                  'film_evidence','letter_evidence' ])
  end

  def invalid_revisions_information
    revisions.where(status: 'Invalido', model: 'information')
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
          if visual_evidence.blank?
            evi=false
          else
            evi=!visual_evidence.id.blank?
          end
        when 2
          if dance_evidence.blank?
            evi=false
          else
            evi=!dance_evidence.id.blank?
          end
        when 3
          if music_evidence.blank?
            evi=false
          else
            evi=!music_evidence.id.blank?
          end
        when 4
          if theater_evidence.blank?
            evi=false
          else
            evi=!theater_evidence.id.blank?
          end
        when 5
          if film_evidence.blank?
            evi=false
          else
            evi=!film_evidence.id.blank?
          end
        when 6
          if letter_evidence.blank?
            evi=false
          else
            evi=!letter_evidence.id.blank?
          end
        end
      end
      return evi
    end
    false
  end

end
