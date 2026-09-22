class BikesController < ApplicationController
  def index
    @bikes = Bike.includes(:customer).by_brand_and_model
  end

  def show
    @bike = Bike.includes(:customer, repairs: { repair_services: :service }).find(params[:id])
  end
end