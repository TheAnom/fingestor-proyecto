module Api
  module V1
    class PagosController < BaseController
      def index
        scope = Pago.includes(:concepto_pago, :estudiante, :usuario)
        if params[:desde].present?
          desde = Date.parse(params[:desde]) rescue nil
          scope = scope.where('fecha >= ?', desde) if desde
        end
        if params[:hasta].present?
          hasta = Date.parse(params[:hasta]) rescue nil
          scope = scope.where('fecha <= ?', hasta) if hasta
        end
        if params[:concepto_id].present?
          scope = scope.where(concepto_pago_id: params[:concepto_id])
        end
        if params[:estudiante_id].present?
          scope = scope.where(estudiante_id: params[:estudiante_id])
        end
        pagos = scope.order(fecha: :desc).limit(200)
        render json: pagos.as_json(only: [:id, :monto, :fecha], include: { concepto_pago: { only: [:id, :nombre] }, estudiante: { only: [:id, :nombre_completo] }, usuario: { only: [:id, :nombre] } })
      end
    end
  end
end
