class ReportDoc < ApplicationRecord

  belongs_to :report


  mount_uploaders  :photos, DocumentsUploader
  serialize :photos, JSON
  mount_uploaders  :video, DocumentsUploader
  serialize :video, JSON
  mount_uploaders  :payslips, DocumentsUploader
  serialize :payslips, JSON
  mount_uploaders  :press, DocumentsUploader
  serialize :press, JSON
  mount_uploaders :publicity, DocumentsUploader
  serialize :publicity, JSON

  def photoss
    photos.map{|x| x.file.filename}.join ','
  end

  def videos
    video.map{|x| x.file.filename}.join ','
  end

  def payslipss
    payslips.map{|x| x.file.filename}.join ','
  end

  def presss
    press.map{|x| x.file.filename}.join ','
  end

  def publicitys
    publicity.map{|x| x.file.filename}.join ','
  end

end
