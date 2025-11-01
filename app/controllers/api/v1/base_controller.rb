module Api
  module V1
    class BaseController < ActionController::API
      before_action :authenticate_token!
      before_action :throttle_api

      private

      def authenticate_token!
        header = request.headers['Authorization']
        token = header.to_s.split(' ').last
        user = token.present? ? Usuario.find_by(api_token: token) : nil
        if user
          @current_api_user = user
        else
          render json: { error: 'Unauthorized' }, status: :unauthorized
        end
      end

      def throttle_api
        key = "api:#{@current_api_user&.id || 'anon'}:#{Time.current.beginning_of_minute.to_i}"
        count = Rails.cache.read(key).to_i
        limit = 60
        if count >= limit
          render json: { error: 'Rate limit exceeded' }, status: :too_many_requests and return
        end
        Rails.cache.write(key, count + 1, expires_in: 2.minutes)
      end
    end
  end
end
