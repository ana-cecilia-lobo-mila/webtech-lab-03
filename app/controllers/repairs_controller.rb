class RepairsController < ApplicationController
  before_action :set_repair, only: [:show, :edit, :update, :destroy]

  def index
    @repairs = Repair.includes(:bike, :mechanic).by_promised_on
  end

  def show
  end

  def new
    @repair = Repair.new(bike_id: params[:bike_id])
    @repair.repair_services.build
  end

  def edit
    @repair.repair_services.build
  end

  def create
    @repair = Repair.new(repair_params)

    if @repair.save
      redirect_to @repair, notice: "Repair for #{@repair.bike.serial_number} was created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @repair.update(repair_params)
      redirect_to @repair, notice: "Repair for #{@repair.bike.serial_number} was updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @repair.destroy
      redirect_to repairs_path, notice: "Repair for #{@repair.bike.serial_number} was deleted successfully.", status: :see_other
    else
      redirect_to @repair, alert: "Repair for #{@repair.bike.serial_number} could not be deleted: #{@repair.errors.full_messages.to_sentence}"
    end
  end

  private

  def set_repair
    @repair = Repair.includes(:bike, :mechanic, repair_services: :service).find(params[:id])
  end

  def repair_params
    params.expect(
      repair: [
        :bike_id,
        :mechanic_id,
        :promised_on,
        :started_on,
        :handed_back_at,
        :state,
        repair_services_attributes: [:id, :service_id, :charged_price, :_destroy]
      ]
    )
  end
end