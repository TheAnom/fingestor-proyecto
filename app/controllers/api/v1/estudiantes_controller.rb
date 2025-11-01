module Api
  module V1
    class EstudiantesController < BaseController
      def index
        q = params[:q].to_s.downcase
        scope = Estudiante.includes(:grado)
        scope = scope.where('LOWER(nombre_completo) LIKE ?', "%#{q}%") if q.present?
        estudiantes = scope.order(:nombre_completo).limit(50)
        render json: estudiantes.as_json(only: [:id, :nombre_completo, :telefono, :grado_id, :institucion], methods: [], include: { grado: { only: [:id, :nombre] } })
      end

      def show
        e = Estudiante.includes(:grado).find_by(id: params[:id])
        return render json: { error: 'Not found' }, status: :not_found unless e
        render json: e.as_json(only: [:id, :nombre_completo, :telefono, :grado_id, :institucion], include: { grado: { only: [:id, :nombre] } })
      end
    end
  end
end
