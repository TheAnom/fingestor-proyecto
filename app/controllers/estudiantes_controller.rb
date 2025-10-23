class EstudiantesController < ApplicationController
  before_action :require_login
  before_action :set_estudiante, only: [:update, :destroy]

  def update
    if @estudiante.update(estudiante_params)
      render json: { success: true, estudiante: {
        id: @estudiante.id,
        nombre_completo: @estudiante.nombre_completo,
        telefono: @estudiante.telefono,
        grado_id: @estudiante.grado_id,
        grado_nombre: @estudiante.grado&.nombre,
        institucion: @estudiante.institucion
      } }
    else
      render json: { success: false, errors: @estudiante.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    # Dejar que ActiveRecord elimine en cascada los registros dependientes (pagos, asignaciones)
    @estudiante.destroy
    head :no_content
  rescue ActiveRecord::InvalidForeignKey => e
    render json: { success: false, error: 'No se pudo eliminar por restricciones de integridad referencial' }, status: :conflict
  end

  private

  def set_estudiante
    @estudiante = Estudiante.find(params[:id])
  end

  def estudiante_params
    params.require(:estudiante).permit(:nombre_completo, :telefono, :grado_id, :institucion)
  end
end
