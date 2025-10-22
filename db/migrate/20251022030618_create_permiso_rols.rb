class CreatePermisoRols < ActiveRecord::Migration[8.0]
  def change
    create_table :permiso_rols do |t|
      t.references :rol, null: false, foreign_key: true
      t.references :permiso, null: false, foreign_key: true

      t.timestamps
    end
  end
end
