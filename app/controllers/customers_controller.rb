class CustomersController < ApplicationController
  before_action :set_customer, only: [:show, :edit, :update, :destroy]

  def index
    authorize Customer, :index?
    @customers = policy_scope(Customer).by_name
  end

  def show
    @bikes = policy_scope(Bike)
      .where(customer_id: @customer.id)
      .by_brand_and_model
  end

  def new
    @customer = Customer.new
    authorize @customer
  end

  def edit
  end

  def create
    @customer = Customer.new(customer_params)
    authorize @customer

    if @customer.save
      redirect_to @customer, notice: "#{@customer.name} was created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @customer.update(customer_params)
      redirect_to @customer, notice: "#{@customer.name} was updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @customer.destroy
      redirect_to customers_path, notice: "#{@customer.name} was deleted successfully.", status: :see_other
    else
      redirect_to @customer, alert: "#{@customer.name} could not be deleted: #{@customer.errors.full_messages.to_sentence}"
    end
  end

  private

  def set_customer
    @customer = Customer.includes(:bikes).find(params[:id])
    authorize @customer
  end

  def customer_params
    params.expect(customer: [:name, :phone])
  end
end