module Api
  class BaseController < ActionController::API
    include ActionController::HttpAuthentication::Token::ControllerMethods

    before_action :authenticate_api_token!

    rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
    rescue_from ActionController::ParameterMissing, with: :render_bad_request
    rescue_from ActionController::BadRequest, with: :render_bad_request
    rescue_from ActionDispatch::Http::Parameters::ParseError, with: :render_bad_request

    private

    def authenticate_api_token!
      authenticated = authenticate_with_http_token do |token, _options|
        expected_token = Rails.application.credentials.dig(:api, :token).to_s

        ActiveSupport::SecurityUtils.secure_compare(token, expected_token)
      end

      render json: { errors: ["Unauthorized"] }, status: :unauthorized unless authenticated
    end

    def render_not_found(exception)
      render json: { errors: [exception.message] }, status: :not_found
    end

    def render_bad_request(exception)
      render json: { errors: [exception.message] }, status: :bad_request
    end
  end
end