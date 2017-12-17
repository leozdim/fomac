class AddDataToModality < ActiveRecord::Migration[5.1]
  def change
    Modality.create(name: 'Artística')
    Modality.create(name: 'Formativa')
    Modality.create(name: 'Difusión')
  end
end
