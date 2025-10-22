class Rol < ApplicationRecord
  has_many :usuarios
  has_many :permiso_roles
  has_many :permisos, through: :permiso_roles
end
