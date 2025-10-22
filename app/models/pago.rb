class Pago < ApplicationRecord
  belongs_to :concepto_pago
  belongs_to :estudiante
  belongs_to :usuario
end
