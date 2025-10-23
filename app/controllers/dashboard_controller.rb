class DashboardController < ApplicationController
  layout "dashboard"

  before_action :require_login
  before_action :set_usuario

  def index
  end

  def ingresos
    # Preparar colecciones para la vista
    @estudiantes = Estudiante.all.order(:nombre_completo)
    @conceptos = ConceptoPago.all.order(:nombre)
  @pagos = Pago.includes(:concepto_pago, :estudiante, :usuario).order(created_at: :desc)

    # Si es POST, crear o actualizar estudiante; si es GET, mostrar formulario
    if request.post?
      @estudiante = Estudiante.new(estudiante_params)

      if @estudiante.save
        # Después de guardar, limpiar los campos y volver a mostrar el formulario
        flash.now[:notice] = "Estudiante guardado correctamente"
        @estudiante = Estudiante.new
        render :ingresos
      else
        flash.now[:alert] = "No se pudo guardar el estudiante"
        render :ingresos, status: :unprocessable_entity
      end
    else
      @estudiante = Estudiante.new
    end
  end

  # POST /dashboard/guardar_pago
  def guardar_pago
    pago = Pago.new(
      concepto_pago_id: params[:concepto_pago_id],
      estudiante_id: params[:estudiante_id],
      usuario_id: session[:usuario_id],
      monto: params[:monto],
      fecha: Date.current
    )

    if pago.save
      redirect_to dashboard_ingresos_path, notice: "Pago registrado correctamente"
    else
      redirect_to dashboard_ingresos_path, alert: "No se pudo registrar el pago"
    end
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

  def estudiante_params
    params.require(:estudiante).permit(:nombre_completo, :telefono, :grado_id, :institucion)
  end
end
