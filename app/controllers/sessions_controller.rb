class SessionsController < ApplicationController
  def new
  end

  def create
    # Busca usuario por nombre
    usuario = Usuario.find_by(nombre: params[:nombre])

    # Valida contraseña (sin cifrado por simplicidad)
    if usuario && usuario.contraseña == params[:contraseña]
      session[:usuario_id] = usuario.id
      redirect_to dashboard_path
    else
      flash[:alert] = "Nombre o contraseña incorrectos"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session.delete(:usuario_id)
    redirect_to login_path, notice: "Sesión cerrada correctamente"
  end
end
