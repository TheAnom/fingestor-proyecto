class CreateEstudiantes < ActiveRecord::Migration[8.0]
  def change
    create_table :estudiantes do |t|
      t.text :nombre_completo
      t.text :telefono
      t.references :grado, null: false, foreign_key: true
      t.text :institucion

      t.timestamps
    end
  end
end
