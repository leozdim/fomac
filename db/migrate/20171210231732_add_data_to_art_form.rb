class AddDataToArtForm < ActiveRecord::Migration[5.1]
  def change
    ArtForm.create(name: 'Artes visuales')
    ArtForm.create(name: 'Danza')
    ArtForm.create(name: 'Música')
    ArtForm.create(name: 'Teatro')
    ArtForm.create(name: 'Cine y video')
    ArtForm.create(name: 'Letras')
  end
end
