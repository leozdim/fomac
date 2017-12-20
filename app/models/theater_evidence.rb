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

  def images
    image.map{|x| x.url}.join ',' 
  end

  def notes
    note.map{|x| x.url}.join ','
  end

  def documents
    document.map{|x| x.url}.join ','
  end

end
