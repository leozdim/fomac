class AddDataToCategories < ActiveRecord::Migration[5.1]
  def change
    Category.create(name: 'Jóvenes creadores' )
    Category.create(name: 'Creadores con trayectoria' )
    Category.create(name: 'Desarrollo artístico individual' )
    Category.create(name: 'Producción artística colectiva' )
  end
end
