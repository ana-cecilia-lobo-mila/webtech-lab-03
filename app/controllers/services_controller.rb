class ServicesController < ApplicationController
  before_action :set_service, only: [:show, :edit, :update, :destroy]

  def index
    @services = Service.by_name
  end

  def show
  end

  def new
    @service = Service.new
  end

  def edit
  end

  def create
    @service = Service.new(service_params)

    if @service.save
      redirect_to @service, notice: "#{@service.name} was created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @service.update(service_params)
      redirect_to @service, notice: "#{@service.name} was updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @service.destroy
      redirect_to services_path, notice: "#{@service.name} was deleted successfully.", status: :see_other
    else
      redirect_to @service, alert: "#{@service.name} could not be deleted: #{@service.errors.full_messages.to_sentence}"
    end
  end

  private

  def set_service
    @service = Service.includes(repair_services: :repair).find(params[:id])
  end

  def service_params
    params.expect(service: [:name, :price])
  end
end