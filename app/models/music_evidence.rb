class MusicEvidence < ApplicationRecord
  belongs_to :project
  mount_uploaders :score, DocumentsUploader
  serialize :score, JSON
  mount_uploaders :note, DocumentsUploader
  serialize :note, JSON
  mount_uploaders :document, DocumentsUploader
  serialize :document, JSON
  validates_presence_of :video, :web , :audio, :score, :note, :document
 
  def scores
    score.map{|x| x.url}.join ',' 
  end

  def notes
    note.map{|x| x.url}.join ','
  end

  def documents
    document.map{|x| x.url}.join ','
  end

end
