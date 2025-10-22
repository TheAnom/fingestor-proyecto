class Estudiante < ApplicationRecord
  belongs_to :grado
  has_many :pagos
  has_many :asignacion_cursos
  has_many :cursos, through: :asignacion_cursos
end
