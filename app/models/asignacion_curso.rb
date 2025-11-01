class AsignacionCurso < ApplicationRecord
  belongs_to :estudiante
  belongs_to :curso
  validates :nota, inclusion: { in: 0..100 }, allow_nil: true
  validates :estudiante_id, uniqueness: { scope: :curso_id }
end
