class CursosController < ApplicationController
  before_action :require_login

  def update
    @curso = Curso.find(params[:id])
    if @curso.update(curso_params)
      render json: { 
        success: true, 
        curso: {
          id: @curso.id,
          nombre: @curso.nombre,
          profesor_id: @curso.profesor_id,
          profesor_nombre: @curso.profesor&.nombre
        }
      }
    else
      render json: { success: false, errors: @curso.errors.full_messages }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    render json: { success: false, errors: ['Curso no encontrado'] }, status: :not_found
  rescue => e
    render json: { success: false, errors: [e.message] }, status: :internal_server_error
  end

  def destroy
    @curso = Curso.find(params[:id])
    if @curso.destroy
      render json: { success: true }
    else
      render json: { success: false, errors: @curso.errors.full_messages }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    render json: { success: false, errors: ['Curso no encontrado'] }, status: :not_found
  rescue => e
    render json: { success: false, errors: [e.message] }, status: :internal_server_error
  end

  private

  def require_login
    unless session[:usuario_id]
      redirect_to login_path, alert: "Debes iniciar sesión"
    end
  end

  def curso_params
    params.require(:curso).permit(:nombre, :profesor_id)
  end
end
