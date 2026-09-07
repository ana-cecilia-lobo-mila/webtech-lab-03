class WheelhouseController < ApplicationController
  def home
  end

  def services
    @services = Service.order(:name)
  end

  def workshop
  end

  def about
  end
end