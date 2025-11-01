class SessionsController < ApplicationController
  before_action :throttle_login, only: :create
  def new
  end

  def create
    # Busca usuario por nombre
    usuario = Usuario.find_by(nombre: params[:nombre])

    # Autentica usando has_secure_password
    if usuario && usuario.authenticate(params[:password])
      reset_session
      session[:usuario_id] = usuario.id
      session[:last_seen_at] = Time.current.to_i
      redirect_to dashboard_path
    else
      flash[:alert] = "Nombre o contrasena incorrectos"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    reset_session
    redirect_to login_path, notice: "Sesión cerrada correctamente"
  end

  private

  def throttle_login
    key = "login:#{request.remote_ip}"
    count = Rails.cache.read(key).to_i
    if count >= 10
      # 429 Too Many Requests
      render :new, status: :too_many_requests and return
    end
    Rails.cache.write(key, count + 1, expires_in: 5.minutes)
  end
end
