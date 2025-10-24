class AsignacionCursosController < ApplicationController
  before_action :set_asignacion, only: [:show, :update, :destroy]

  def show
    render json: { 
      asignacion: {
        id: @asignacion.id,
        estudiante_id: @asignacion.estudiante_id,
        estudiante_nombre: @asignacion.estudiante&.nombre_completo,
        curso_id: @asignacion.curso_id,
        curso_nombre: @asignacion.curso&.nombre,
        nota: @asignacion.nota
      }
    }
  end

  def update
    if @asignacion.update(asignacion_params)
      render json: { 
        success: true, 
        asignacion: {
          id: @asignacion.id,
          estudiante_id: @asignacion.estudiante_id,
          estudiante_nombre: @asignacion.estudiante&.nombre_completo,
          curso_id: @asignacion.curso_id,
          curso_nombre: @asignacion.curso&.nombre,
          nota: @asignacion.nota
        }
      }
    else
      render json: { success: false, errors: @asignacion.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @asignacion.destroy
    render json: { success: true }
  end

  private

  def set_asignacion
    @asignacion = AsignacionCurso.find(params[:id])
  end

  def asignacion_params
    params.require(:asignacion).permit(:estudiante_id, :curso_id, :nota)
  end
end
