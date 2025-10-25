class DashboardController < ApplicationController
  layout "dashboard"

  before_action :require_login
  before_action :set_usuario

  def index
    @estudiantes_count = Estudiante.count
    @pagos_count = Pago.count
    @hoy = Date.current
    @ingresos_total = Pago.sum(:monto)
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
        if request.xhr? || request.format.json?
          render json: { 
            success: true, 
            estudiante: {
              id: @estudiante.id,
              nombre_completo: @estudiante.nombre_completo,
              telefono: @estudiante.telefono,
              grado_id: @estudiante.grado_id,
              grado_nombre: @estudiante.grado&.nombre,
              institucion: @estudiante.institucion
            }
          }
        else
          # Después de guardar, limpiar los campos y volver a mostrar el formulario
          flash.now[:notice] = "Estudiante guardado correctamente"
          @estudiante = Estudiante.new
          render :ingresos
        end
      else
        if request.xhr? || request.format.json?
          render json: { success: false, errors: @estudiante.errors.full_messages }, status: :unprocessable_entity
        else
          flash.now[:alert] = "No se pudo guardar el estudiante"
          render :ingresos, status: :unprocessable_entity
        end
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
      if request.xhr? || request.format.json?
        render json: { success: true, pago: {
          id: pago.id,
          concepto_pago_id: pago.concepto_pago_id,
          concepto_pago_nombre: pago.concepto_pago&.nombre,
          estudiante_id: pago.estudiante_id,
          estudiante_nombre: pago.estudiante&.nombre_completo,
          usuario_id: pago.usuario_id,
          usuario_nombre: pago.usuario&.nombre,
          monto: pago.monto,
          fecha: pago.fecha
        } }
      else
        redirect_to dashboard_ingresos_path, notice: "Pago registrado correctamente"
      end
    else
      if request.xhr? || request.format.json?
        render json: { success: false, errors: pago.errors.full_messages }, status: :unprocessable_entity
      else
        redirect_to dashboard_ingresos_path, alert: "No se pudo registrar el pago"
      end
    end
  end

  def consultas
  end

  # GET /dashboard/consultas_datos
  def consultas_datos
    estudiante = Estudiante.includes(:grado).find_by(id: params[:estudiante_id])
    return render json: { success: false, error: 'Estudiante no encontrado' }, status: :not_found unless estudiante

    # Conceptos esperados: Inscripcion + meses Enero..Noviembre
    conceptos = [
      'Inscripcion', 'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
      'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre'
    ]

    pagos_raw = Pago.includes(:concepto_pago)
                    .where(estudiante_id: estudiante.id, concepto_pago: { nombre: conceptos })

    # Tomar el pago más reciente por concepto
    pagos_por_concepto = {}
    pagos_raw.each do |p|
      nombre_concepto = p.concepto_pago&.nombre
      next unless nombre_concepto
      if pagos_por_concepto[nombre_concepto].nil? || (p.fecha && pagos_por_concepto[nombre_concepto][:fecha] && p.fecha > pagos_por_concepto[nombre_concepto][:fecha])
        pagos_por_concepto[nombre_concepto] = { monto: p.monto, fecha: p.fecha }
      else
        pagos_por_concepto[nombre_concepto] ||= { monto: p.monto, fecha: p.fecha }
      end
    end

    pagos_hash = {}
    conceptos.each do |c|
      pagos_hash[c] = pagos_por_concepto[c] ? pagos_por_concepto[c][:monto] : nil
    end

    # Calcular solvencia del mes actual con regla: después del día 5, si no está pagado el mes actual => No solvente; en otro caso => Solvente
    hoy = Date.current
    meses_labels = [nil, 'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre']
    mes_actual_label = meses_labels[hoy.month]
    # Solo se consideran Enero..Noviembre como columnas; si es Diciembre, considerar solvente por defecto salvo que se requiera otra regla
    requiere_mes = conceptos.include?(mes_actual_label)
    pagado_mes_actual = requiere_mes ? pagos_hash[mes_actual_label].present? : true
    solvente = if hoy.day > 5
      pagado_mes_actual
    else
      true
    end

    # Solvencia exámenes / papelería
    exam_labels = ['Papeleria', 'Examen uno', 'Examen dos', 'Examen tres', 'Examen cuatro']
    exams_pagos = Pago.includes(:concepto_pago)
                      .where(estudiante_id: estudiante.id, concepto_pago: { nombre: exam_labels })
    exams_status = exam_labels.index_with do |label|
      exams_pagos.any? { |p| p.concepto_pago&.nombre == label }
    end

    # Asignaciones y promedio
    asignaciones = AsignacionCurso.includes(:curso).where(estudiante_id: estudiante.id)
    asignaciones_list = asignaciones.map do |a|
      { curso_nombre: a.curso&.nombre, nota: a.nota }
    end
    notas = asignaciones.map(&:nota).compact.map(&:to_f)
    promedio = notas.any? ? (notas.sum / notas.size) : nil

    render json: {
      success: true,
      estudiante: {
        id: estudiante.id,
        nombre_completo: estudiante.nombre_completo,
        institucion: estudiante.institucion,
        grado_id: estudiante.grado_id,
        grado_nombre: estudiante.grado&.nombre,
        telefono: estudiante.telefono
      },
      pagos: pagos_hash,
      solvente: solvente,
      examenes: exams_status,
      asignaciones: asignaciones_list,
      promedio: promedio
    }
  end

  def control_usuarios
    @estudiantes = Estudiante.all.order(:nombre_completo)
    @cursos = Curso.includes(:profesor).all.order(:nombre)
    @profesores = Profesor.all.order(:nombre)
    @usuarios = Usuario.includes(:rol).all.order(:nombre)
    @roles = Rol.all.order(:nombre)
    @asignaciones = AsignacionCurso.includes(:estudiante, :curso).order(created_at: :desc)
  end

  def buscar_estudiantes
    query = params[:q]
    estudiantes = Estudiante.includes(:grado)
                           .where("LOWER(nombre_completo) LIKE ?", "%#{query.downcase}%")
                           .limit(10)
                           .map do |e|
      {
        id: e.id,
        nombre_completo: e.nombre_completo,
        grado_nombre: e.grado&.nombre
      }
    end

    render json: { estudiantes: estudiantes }
  end

  def guardar_asignacion
    if params[:asignacion][:id].present?
      asignacion = AsignacionCurso.find(params[:asignacion][:id])
      asignacion.assign_attributes(asignacion_params)
    else
      asignacion = AsignacionCurso.new(asignacion_params)
    end

    if asignacion.save
      render json: { 
        success: true, 
        asignacion: {
          id: asignacion.id,
          estudiante_id: asignacion.estudiante_id,
          estudiante_nombre: asignacion.estudiante&.nombre_completo,
          curso_id: asignacion.curso_id,
          curso_nombre: asignacion.curso&.nombre,
          nota: asignacion.nota
        }
      }
    else
      render json: { success: false, errors: asignacion.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def guardar_curso
    if params[:curso][:id].present?
      curso = Curso.find(params[:curso][:id])
      curso.assign_attributes(curso_params.except(:id))
    else
      curso = Curso.new(curso_params.except(:id))
    end

    if curso.save
      render json: { 
        success: true, 
        curso: {
          id: curso.id,
          nombre: curso.nombre,
          profesor_id: curso.profesor_id,
          profesor_nombre: curso.profesor&.nombre
        }
      }
    else
      render json: { success: false, errors: curso.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def guardar_profesor
    if params[:profesor][:id].present?
      profesor = Profesor.find(params[:profesor][:id])
      profesor.assign_attributes(profesor_params.except(:id))
    else
      profesor = Profesor.new(profesor_params.except(:id))
    end

    if profesor.save
      render json: { 
        success: true, 
        profesor: {
          id: profesor.id,
          nombre: profesor.nombre,
          telefono: profesor.telefono
        }
      }
    else
      render json: { success: false, errors: profesor.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def guardar_usuario
    if params[:usuario][:id].present?
      usuario = Usuario.find(params[:usuario][:id])
      usuario.assign_attributes(usuario_params.except(:id))
    else
      usuario = Usuario.new(usuario_params.except(:id))
    end

    if usuario.save
      render json: { 
        success: true, 
        usuario: {
          id: usuario.id,
          nombre: usuario.nombre,
          rol_id: usuario.rol_id,
          rol_nombre: usuario.rol&.nombre
        }
      }
    else
      render json: { success: false, errors: usuario.errors.full_messages }, status: :unprocessable_entity
    end
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

  def asignacion_params
    params.require(:asignacion).permit(:estudiante_id, :curso_id, :nota, :id)
  end

  def curso_params
    params.require(:curso).permit(:nombre, :profesor_id, :id)
  end

  def profesor_params
    params.require(:profesor).permit(:nombre, :telefono, :id)
  end

  def usuario_params
    params.require(:usuario).permit(:nombre, :contraseña, :rol_id, :id)
  end
end
