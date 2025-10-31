class Usuario < ApplicationRecord
  belongs_to :rol
  has_many :pagos
  has_secure_password
  validates :nombre, presence: true, uniqueness: true
  validates :rol, presence: true
  validates :password, length: { minimum: 6 }, allow_nil: true
end
