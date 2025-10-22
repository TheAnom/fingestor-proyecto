class Curso < ApplicationRecord
  belongs_to :profesor
  has_many :asignacion_cursos
  has_many :estudiantes, through: :asignacion_cursos
end
