class CreatePermisos < ActiveRecord::Migration[8.0]
  def change
    create_table :permisos do |t|
      t.text :nombre

      t.timestamps
    end
  end
end
