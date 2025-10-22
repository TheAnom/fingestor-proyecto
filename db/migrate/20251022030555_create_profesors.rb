class CreateProfesors < ActiveRecord::Migration[8.0]
  def change
    create_table :profesors do |t|
      t.text :nombre
      t.text :telefono

      t.timestamps
    end
  end
end
