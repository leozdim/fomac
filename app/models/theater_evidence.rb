class TheaterEvidence < ApplicationRecord
  belongs_to :project
  mount_uploader :letter, DocumentsUploader
  mount_uploader :script, DocumentsUploader
  mount_uploaders :note, DocumentsUploader
  serialize :note, JSON
  mount_uploaders :document, DocumentsUploader
  serialize :document, JSON
  mount_uploaders :image, DocumentsUploader
  serialize :image, JSON
  # validates_presence_of :video, :web , :script, :letter, :image, :note, :document
  ART_FORM_ID=4

  def images
      image.map{|x| x.file.filename}.join ',' 
  end

  def notes
      note.map{|x| x.file.filename}.join ','
  end

  def documents
      document.map{|x| x.file.filename}.join ','
  end

end
