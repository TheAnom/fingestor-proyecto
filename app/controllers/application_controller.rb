class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :check_session_expiration
  before_action :update_last_activity

  private

  # Require a logged-in usuario (sets redirect if not present)
  def require_login
    unless session[:usuario_id]
      redirect_to login_path, alert: "Debes iniciar sesión"
    end
  end

  # Set the @usuario if session exists (safe find_by)
  def set_usuario
    @usuario = Usuario.find_by(id: session[:usuario_id])
  end

  # Helper to access current user
  def current_user
    @current_user ||= Usuario.find_by(id: session[:usuario_id])
  end
  helper_method :current_user

  def require_role(*roles)
    user_role = current_user&.rol&.nombre
    unless user_role && roles.map(&:to_s).include?(user_role.to_s)
      redirect_to dashboard_path, alert: "Acceso no autorizado"
    end
  end

  def admin?
    current_user&.rol&.nombre == 'administrador'
  end
  helper_method :admin?

  def session_timeout_seconds
    30.minutes.to_i
  end

  def check_session_expiration
    last = session[:last_seen_at]
    if last && Time.at(last) < session_timeout_seconds.seconds.ago
      reset_session
      redirect_to login_path, alert: "Sesión expirada"
    end
  end

  def update_last_activity
    if session[:usuario_id]
      session[:last_seen_at] = Time.current.to_i
    end
  end
end
