class CreatePagos < ActiveRecord::Migration[8.0]
  def change
    create_table :pagos do |t|
      t.references :concepto_pago, null: false, foreign_key: true
      t.references :estudiante, null: false, foreign_key: true
      t.references :usuario, null: false, foreign_key: true
      t.float :monto
      t.date :fecha

      t.timestamps
    end
  end
end
