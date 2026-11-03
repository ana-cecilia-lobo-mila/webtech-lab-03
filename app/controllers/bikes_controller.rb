class BikesController < ApplicationController
  before_action :set_bike, only: [:show, :edit, :update, :destroy]

  def index
    authorize Bike, :index?
    @bikes = policy_scope(Bike).includes(:customer).by_brand_and_model
  end

  def show
    @repairs = policy_scope(Repair)
      .where(bike_id: @bike.id)
      .includes(:bike, :mechanic, taken_in_by: :mechanic)
      .with_attached_intake_photos
      .with_rich_text_diagnosis
      .by_promised_on
  end

  def new
    @bike = Bike.new(customer_id: params[:customer_id])
    authorize @bike
  end

  def edit
  end

  def create
    @bike = Bike.new(bike_params)
    authorize @bike

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
    @bike = Bike.includes(:customer).find(params[:id])
    authorize @bike
  end

  def bike_params
    params.expect(bike: [:serial_number, :brand, :model, :color, :customer_id])
  end
end