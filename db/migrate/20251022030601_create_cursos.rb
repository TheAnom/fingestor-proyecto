class CreateCursos < ActiveRecord::Migration[8.0]
  def change
    create_table :cursos do |t|
      t.text :nombre
      t.references :profesor, null: false, foreign_key: true

      t.timestamps
    end
  end
end
