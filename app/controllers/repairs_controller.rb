class RepairsController < ApplicationController
  def index
    @repairs = Repair.includes(:bike, :mechanic).by_promised_on
  end

  def show
    @repair = Repair.includes(:bike, repair_services: :service).find(params[:id])
  end
end