class ProfesoresController < ApplicationController
  before_action :require_login

  def update
    @profesor = Profesor.find(params[:id])
    if @profesor.update(profesor_params)
      render json: { 
        success: true, 
        profesor: {
          id: @profesor.id,
          nombre: @profesor.nombre,
          telefono: @profesor.telefono
        }
      }
    else
      render json: { success: false, errors: @profesor.errors.full_messages }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    render json: { success: false, errors: ['Profesor no encontrado'] }, status: :not_found
  rescue => e
    render json: { success: false, errors: [e.message] }, status: :internal_server_error
  end

  def destroy
    @profesor = Profesor.find(params[:id])
    if @profesor.destroy
      render json: { success: true }
    else
      render json: { success: false, errors: @profesor.errors.full_messages }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    render json: { success: false, errors: ['Profesor no encontrado'] }, status: :not_found
  rescue => e
    render json: { success: false, errors: [e.message] }, status: :internal_server_error
  end

  private

  def require_login
    unless session[:usuario_id]
      redirect_to login_path, alert: "Debes iniciar sesión"
    end
  end

  def profesor_params
    params.require(:profesor).permit(:nombre, :telefono)
  end
end
