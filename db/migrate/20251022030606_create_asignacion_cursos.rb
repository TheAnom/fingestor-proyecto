class CreateAsignacionCursos < ActiveRecord::Migration[8.0]
  def change
    create_table :asignacion_cursos do |t|
      t.references :estudiante, null: false, foreign_key: true
      t.references :curso, null: false, foreign_key: true
      t.integer :nota

      t.timestamps
    end
  end
end
