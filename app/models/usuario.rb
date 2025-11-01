class Usuario < ApplicationRecord
  belongs_to :rol
  has_many :pagos
  has_secure_password
  has_secure_token :api_token
  validates :nombre, presence: true, uniqueness: true
  validates :rol, presence: true
  validates :password, length: { minimum: 8 }, allow_nil: true
end
