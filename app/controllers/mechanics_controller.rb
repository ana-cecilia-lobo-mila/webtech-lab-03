class MechanicsController < ApplicationController
  before_action :set_mechanic, only: [:show, :edit, :update, :destroy]

  def index
    authorize Mechanic, :index?
    @mechanics = policy_scope(Mechanic).by_name
  end

  def show
    @repairs = policy_scope(Repair)
      .where(mechanic_id: @mechanic.id)
      .includes(:bike)
      .by_promised_on
  end

  def new
    @mechanic = Mechanic.new
    authorize @mechanic
  end

  def edit
  end

  def create
    @mechanic = Mechanic.new(mechanic_params)
    authorize @mechanic

    if @mechanic.save
      redirect_to @mechanic, notice: "#{@mechanic.name} was created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @mechanic.update(mechanic_params)
      redirect_to @mechanic, notice: "#{@mechanic.name} was updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @mechanic.destroy
      redirect_to mechanics_path, notice: "#{@mechanic.name} was deleted successfully.", status: :see_other
    else
      redirect_to @mechanic, alert: "#{@mechanic.name} could not be deleted: #{@mechanic.errors.full_messages.to_sentence}"
    end
  end

  private

  def set_mechanic
    @mechanic = Mechanic.find(params[:id])
    authorize @mechanic
  end

  def mechanic_params
    params.expect(mechanic: [:name])
  end
end