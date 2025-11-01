class AddUniqueIndexToAsignacionCursos < ActiveRecord::Migration[8.1]
  def change
    add_index :asignacion_cursos, [:estudiante_id, :curso_id], unique: true, name: 'index_asignacion_unico_estudiante_curso'
  end
end
