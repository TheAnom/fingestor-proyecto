class CreateGrados < ActiveRecord::Migration[8.0]
  def change
    create_table :grados do |t|
      t.text :nombre

      t.timestamps
    end
  end
end
