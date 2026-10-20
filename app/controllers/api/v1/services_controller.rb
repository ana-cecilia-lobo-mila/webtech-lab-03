module Api
  module V1
    class ServicesController < Api::BaseController
      skip_before_action :authenticate_api_token!, only: [:index, :show]

      def index
        services = Service.by_name.left_joins(:repair_services).select("services.*, COUNT(DISTINCT repair_services.repair_id) AS repairs_count").group("services.id")

        render json: services.map { |service| service_document(service) }
      end

      def show
        service = Service.left_joins(:repair_services).select("services.*, COUNT(DISTINCT repair_services.repair_id) AS repairs_count").group("services.id").find(params[:id])

        render json: service_document(service)
      end

      def create
        service = Service.new(service_params)

        if service.save
          service = Service.left_joins(:repair_services).select("services.*, COUNT(DISTINCT repair_services.repair_id) AS repairs_count").group("services.id").find(service.id)

          render json: service_document(service), status: :created, location: api_v1_service_url(service)
        else
          render json: { errors: service.errors.full_messages },status: :unprocessable_entity
        end
      end

      private

      def service_document(service)
        {
          id: service.id,
          name: service.name,
          price: service.price.to_s,
          repairs_count: service.repairs_count.to_i
        }
      end

      def service_params
        params.expect(service: [:name, :price])
      end
    end
  end
end