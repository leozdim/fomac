class AddDataToArtActivity < ActiveRecord::Migration[5.1]
  def change
    ArtActivity.create modality_id: 1, contributions: 3, kind: 'presentaciones', name: 'Presentaciones escénicas'
    ArtActivity.create modality_id: 1, contributions: 3, kind: 'presentaciones', name: 'Conciertos'
    ArtActivity.create modality_id: 1, contributions: 3, kind: 'presentaciones', name: 'Recitales individuales o grupales'

    ArtActivity.create modality_id: 2, contributions: 20, kind: 'horas', name: 'Talleres'
    ArtActivity.create modality_id: 2, contributions: 5, kind: 'conferencias', name: 'Cursos'

    ArtActivity.create modality_id: 3, contributions: 5, kind: 'presentaciones', name: 'Conferencias'
    ArtActivity.create modality_id: 3, contributions: 5, kind: 'presentaciones', name: 'Mesa redondas'
    ArtActivity.create modality_id: 3, contributions: 5, kind: 'presentaciones', name: 'Lecturas públicas'
  end
end
