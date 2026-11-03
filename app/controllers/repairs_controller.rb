class RepairsController < ApplicationController
  before_action :set_repair, only: [:show, :edit, :update, :destroy, :destroy_intake_photo]

  def index
    authorize Repair, :index?
    @repairs = policy_scope(Repair)
      .includes(:bike, :mechanic, taken_in_by: :mechanic)
      .with_attached_intake_photos
      .with_rich_text_diagnosis
      .by_promised_on
  end

  def show
  end

  def new
    @repair = Repair.new(bike_id: params[:bike_id])
    authorize @repair

    3.times { @repair.repair_services.build }
  end

  def edit
    @repair.repair_services.build
  end

  def create
    @repair = Repair.new
    authorize @repair

    @repair.assign_attributes(repair_params)
    @repair.taken_in_by = Current.user

    if @repair.save
      redirect_to @repair, notice: "Repair for #{@repair.bike.serial_number} was created successfully."
    else
      @repair.repair_services.build if @repair.repair_services.empty?
      render :new, status: :unprocessable_entity
    end
  end

  def update
    attributes = repair_params
    photos = attributes[:intake_photos]&.reject(&:blank?)
    attributes = attributes.except(:intake_photos)

    @repair.assign_attributes(attributes)

    if photos.present?
      existing_blobs = @repair.intake_photos.blobs.to_a
      @repair.intake_photos = existing_blobs + photos
    end

    if @repair.save
      redirect_to @repair, notice: "Repair for #{@repair.bike.serial_number} was updated successfully."
    else
      @repair.repair_services.build if @repair.repair_services.empty?
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

  def destroy_intake_photo
    photo = @repair.intake_photos.attachments.find(params[:attachment_id])
    photo.purge

    redirect_to @repair, notice: "Intake photo was removed successfully.", status: :see_other
  end

  private

  def set_repair
    repair_id = params[:id] || params[:repair_id]

    @repair = Repair
      .includes(:bike, :mechanic, { taken_in_by: :mechanic }, repair_services: :service)
      .with_attached_intake_photos
      .with_rich_text_diagnosis
      .find(repair_id)

    authorize @repair
  end
  
  def repair_params
    params.permit(repair: policy(@repair).permitted_attributes).fetch(:repair, ActionController::Parameters.new)
  end
end