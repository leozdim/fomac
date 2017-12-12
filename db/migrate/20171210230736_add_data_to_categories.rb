class AddDataToCategories < ActiveRecord::Migration[5.1]
  def change
    Category.create(name: 'Jóvenes creadores', key: :JC , single: true)
    Category.create(name: 'Creadores con trayectoria', key: :CCT , single: true)
    Category.create(name: 'Desarrollo artístico individual', key: :DAI , single: true)
    Category.create(name: 'Producción artística colectiva', key: :PAC , single: false)
  end
end
