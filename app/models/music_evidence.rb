class MusicEvidence < ApplicationRecord
  belongs_to :project
  mount_uploaders :score, DocumentsUploader
  serialize :score, JSON
  mount_uploaders :note, DocumentsUploader
  serialize :note, JSON
  mount_uploaders :document, DocumentsUploader
  serialize :document, JSON
  validates_presence_of :video, :web , :audio, :score, :note, :document
  ART_FORM_ID=3
 
  def scores
      score.map{|x| x.file.filename}.join ',' 
  end

  def notes
      note.map{|x| x.file.filename}.join ','
  end

  def documents
      document.map{|x| x.file.filename}.join ','
  end

end
