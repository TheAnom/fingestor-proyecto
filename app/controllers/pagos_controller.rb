class PagosController < ApplicationController
  before_action :require_login
  before_action :set_pago, only: [:update, :destroy]

  def update
    if @pago.update(pago_params)
      render json: { success: true, pago: {
        id: @pago.id,
        concepto_pago_id: @pago.concepto_pago_id,
        concepto_pago_nombre: @pago.concepto_pago&.nombre,
        estudiante_id: @pago.estudiante_id,
        estudiante_nombre: @pago.estudiante&.nombre_completo,
        monto: @pago.monto,
        fecha: @pago.fecha
      } }
    else
      render json: { success: false, errors: @pago.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @pago.destroy
    head :no_content
  rescue ActiveRecord::InvalidForeignKey => e
    render json: { success: false, error: 'No se pudo eliminar el pago por restricciones de integridad referencial' }, status: :conflict
  end

  private

  def set_pago
    @pago = Pago.find(params[:id])
  end

  def pago_params
    params.permit(:concepto_pago_id, :estudiante_id, :monto)
  end
end
