class CreateRols < ActiveRecord::Migration[8.0]
  def change
    create_table :rols do |t|
      t.text :nombre

      t.timestamps
    end
  end
end
