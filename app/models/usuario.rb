class Usuario < ApplicationRecord
  belongs_to :rol
  has_many :pagos
end
