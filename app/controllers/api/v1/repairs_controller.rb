module Api
    module V1
        class RepairsController < Api::BaseController

        def index
            repairs = Repair.newest_first.preload(
            bike: :customer,
            repair_services: :service
            )

            if params[:state].present?
            unless Repair.states.key?(params[:state])
                raise ActionController::BadRequest,
                    "Invalid state. Valid states: #{Repair.states.keys.join(', ')}"
            end

            repairs = repairs.where(state: params[:state])
            end

            render json: repairs.map { |repair| repair_document(repair) }
        end

        def show
            repair = Repair.preload(
            bike: :customer,
            repair_services: :service
            ).find(params[:id])

            render json: repair_document(repair)
        end

        private

        def repair_document(repair)
            {
                id: repair.id,
                state: repair.state,
                started_on: repair.started_on,
                promised_on: repair.promised_on,
                handed_back_at: repair.handed_back_at,

                bike: {
                    brand: repair.bike.brand,
                    model: repair.bike.model,
                    serial_number: repair.bike.serial_number
                },

                customer: {
                    name: repair.bike.customer.name
                },

                lines: repair.repair_services.map do |line|
                    {
                    service_name: line.service.name,
                    charged_price: line.charged_price.to_s
                    }
                end,

                total: repair.repair_services.sum(&:charged_price).to_s,
                overdue: repair.overdue?,
                customer_answer: customer_answer(repair)
            }
            end

            def customer_answer(repair)
                return repair.state if repair.approved? || repair.rejected?

                nil
            end
        end
    end
end