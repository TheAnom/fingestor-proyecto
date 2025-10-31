class SessionsController < ApplicationController
  def new
  end

  def create
    # Busca usuario por nombre
    usuario = Usuario.find_by(nombre: params[:nombre])

    # Autentica usando has_secure_password
    if usuario && usuario.authenticate(params[:password])
      session[:usuario_id] = usuario.id
      redirect_to dashboard_path
    else
      flash[:alert] = "Nombre o contrasena incorrectos"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session.delete(:usuario_id)
    redirect_to login_path, notice: "Sesión cerrada correctamente"
  end
end
