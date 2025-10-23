class DashboardController < ApplicationController
  layout "dashboard"

  before_action :require_login
  before_action :set_usuario

  def index
  end

  def ingresos
  end

  def consultas
  end

  def control_usuarios
  end

  private

  def require_login
    unless session[:usuario_id]
      redirect_to login_path, alert: "Debes iniciar sesión"
    end
  end

  def set_usuario
    @usuario = Usuario.find(session[:usuario_id])
  end
end
