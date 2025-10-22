class CreateUsuarios < ActiveRecord::Migration[8.0]
  def change
    create_table :usuarios do |t|
      t.text :nombre
      t.text :contraseña
      t.references :rol, null: false, foreign_key: true

      t.timestamps
    end
  end
end
