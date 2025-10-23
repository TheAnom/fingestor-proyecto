class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

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
end
