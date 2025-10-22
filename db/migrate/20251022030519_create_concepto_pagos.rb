class CreateConceptoPagos < ActiveRecord::Migration[8.0]
  def change
    create_table :concepto_pagos do |t|
      t.text :nombre

      t.timestamps
    end
  end
end
