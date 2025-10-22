class Permiso < ApplicationRecord
  has_many :permiso_roles
  has_many :roles, through: :permiso_roles
end
