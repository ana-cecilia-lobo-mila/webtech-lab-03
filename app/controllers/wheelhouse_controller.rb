class WheelhouseController < ApplicationController
  def home
  end

  def services
    @services = [
       { name: "Foreign exchange regulations", price: 10000 },
      { name: "Brake adjustment", price: 10000 },
      { name: "Wheel truing", price: 10000 },
      { name: "Front or rear hub maintenance", price: 12000 },
      { name: "Engine maintenance", price: 14000 },
      { name: "Chain replacement", price: 10000 },
      { name: "Tire replacement", price: 8000 },
      { name: "Tube replacement", price: 7000 },
      { name: "Steering maintenance cleaning", price: 12000 },
      { name: "Camera switch", price: 2000 },
      { name: "Chain lubrication", price: 5000 },
      { name: "Safety inspection", price: 7000 }
    ]
  end

  def workshop
  end

  def about
  end
end