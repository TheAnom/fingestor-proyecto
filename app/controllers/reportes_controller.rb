class ReportesController < ApplicationController
  before_action :require_login
  before_action -> { require_role('administrador') }, only: [:mensual]
  before_action -> { require_role('administrador', 'consultor') }, only: [:estado_cuenta]


  def mensual
    desde = params[:desde].present? ? Date.parse(params[:desde]) : Date.current.beginning_of_month
    hasta = params[:hasta].present? ? Date.parse(params[:hasta]) : Date.current.end_of_month

    pagos = Pago.includes(:concepto_pago, :estudiante, :usuario)
                .where(fecha: desde..hasta)
                .order(:fecha)

    total = pagos.sum(:monto)
    por_concepto = pagos.group_by { |p| p.concepto_pago&.nombre.to_s }
                        .transform_values { |rows| rows.sum { |r| r.monto.to_f } }

    @desde = desde
    @hasta = hasta
    @pagos = pagos
    @total = total
    @por_concepto = por_concepto

    # Descargar como HTML si se solicita
    if params[:download].present?
      html = render_to_string(template: 'reportes/mensual', formats: [:html], layout: false)
      return send_data html, filename: "reporte_mensual_#{desde}_#{hasta}.html", type: 'text/html', disposition: 'attachment'
    end

    respond_to do |format|
      format.html { render :mensual }
      format.json do
        render json: { desde: desde, hasta: hasta, total: total, por_concepto: por_concepto, pagos: pagos.as_json(only: [:id, :monto, :fecha], methods: [], include: { concepto_pago: { only: [:id, :nombre] }, estudiante: { only: [:id, :nombre_completo] }, usuario: { only: [:id, :nombre] } }) }
      end
      format.any { render :mensual, formats: :html }
    end
  end

  def estado_cuenta
    estudiante = Estudiante.find_by(id: params[:estudiante_id])
    return render json: { error: 'Estudiante no encontrado' }, status: :not_found unless estudiante

    pagos = Pago.includes(:concepto_pago)
                .where(estudiante_id: estudiante.id)
                .order(:fecha)

    total_pagado = pagos.sum(:monto)
    por_concepto = pagos.group_by { |p| p.concepto_pago&.nombre.to_s }
                        .transform_values { |rows| rows.sum { |r| r.monto.to_f } }

    @estudiante = estudiante
    @pagos = pagos
    @total_pagado = total_pagado
    @por_concepto = por_concepto

    # Descargar como HTML si se solicita
    if params[:download].present?
      html = render_to_string(template: 'reportes/estado_cuenta', formats: [:html], layout: false)
      return send_data html, filename: "estado_cuenta_#{estudiante.id}.html", type: 'text/html', disposition: 'attachment'
    end

    respond_to do |format|
      format.html { render :estado_cuenta }
      format.json do
        render json: { estudiante: { id: estudiante.id, nombre_completo: estudiante.nombre_completo }, total_pagado: total_pagado, por_concepto: por_concepto, pagos: pagos.as_json(only: [:id, :monto, :fecha], include: { concepto_pago: { only: [:id, :nombre] } }) }
      end
      format.any { render :estado_cuenta, formats: :html }
    end
  end
end
