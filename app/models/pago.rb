class Pago < ApplicationRecord
  belongs_to :concepto_pago
  belongs_to :estudiante
  belongs_to :usuario
  validates :concepto_pago, :estudiante, :usuario, presence: true
  validates :monto, numericality: { greater_than: 0 }
  validates :fecha, presence: true
end
