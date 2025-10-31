class Estudiante < ApplicationRecord
  belongs_to :grado
  # Cuando se elimina un estudiante, eliminar también sus pagos y asignaciones para mantener integridad
  has_many :pagos, dependent: :destroy
  has_many :asignacion_cursos, dependent: :destroy
  has_many :cursos, through: :asignacion_cursos
  validates :nombre_completo, presence: true
  validates :grado, presence: true
end
