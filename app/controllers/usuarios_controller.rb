class UsuariosController < ApplicationController
  before_action :require_login

  def update
    @usuario = Usuario.find(params[:id])
    if @usuario.update(usuario_params)
      render json: { 
        success: true, 
        usuario: {
          id: @usuario.id,
          nombre: @usuario.nombre,
          rol_id: @usuario.rol_id,
          rol_nombre: @usuario.rol&.nombre
        }
      }
    else
      render json: { success: false, errors: @usuario.errors.full_messages }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    render json: { success: false, errors: ['Usuario no encontrado'] }, status: :not_found
  rescue => e
    render json: { success: false, errors: [e.message] }, status: :internal_server_error
  end

  def destroy
    @usuario = Usuario.find(params[:id])
    if @usuario.destroy
      render json: { success: true }
    else
      render json: { success: false, errors: @usuario.errors.full_messages }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    render json: { success: false, errors: ['Usuario no encontrado'] }, status: :not_found
  rescue => e
    render json: { success: false, errors: [e.message] }, status: :internal_server_error
  end

  private

  def require_login
    unless session[:usuario_id]
      redirect_to login_path, alert: "Debes iniciar sesión"
    end
  end

  def usuario_params
    params.require(:usuario).permit(:nombre, :contraseña, :rol_id)
  end
end
