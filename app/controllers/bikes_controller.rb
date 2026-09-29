class BikesController < ApplicationController
  before_action :set_bike, only: [:show, :edit, :update, :destroy]
  def index
    @bikes = Bike.includes(:customer).by_brand_and_model
  end

  def show
  end

  def new
    @bike = Bike.new(customer_id: params[:customer_id])
  end

  def edit
  end

  def create
    @bike = Bike.new(bike_params)

    if @bike.save
      redirect_to @bike, notice: "#{@bike.serial_number} was created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @bike.update(bike_params)
      redirect_to @bike, notice: "#{@bike.serial_number} was updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @bike.destroy
      redirect_to bikes_path, notice: "#{@bike.serial_number} was deleted successfully.", status: :see_other
    else
      redirect_to @bike, alert: "#{@bike.serial_number} could not be deleted: #{@bike.errors.full_messages.to_sentence}"
    end
  end


  private

  def set_bike
    @bike = Bike.includes(:customer, repairs: { repair_services: :service }).find(params[:id])
  end

  def bike_params
    params.expect(bike: [:serial_number, :brand, :model, :color, :customer_id])
  end
end