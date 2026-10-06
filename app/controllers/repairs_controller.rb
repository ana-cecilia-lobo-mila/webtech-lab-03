class RepairsController < ApplicationController
  before_action :set_repair, only: [:show, :edit, :update, :destroy, :destroy_intake_photo]

  def index
    @repairs = Repair
      .includes(:bike, :mechanic)
      .with_attached_intake_photos
      .with_rich_text_diagnosis
      .by_promised_on
  end

  def show
  end

  def new
    @repair = Repair.new(bike_id: params[:bike_id])
    @repair.repair_services.build
  end

  def edit
    @repair.repair_services.build
  end

  def create
    @repair = Repair.new(repair_params)

    if @repair.save
      redirect_to @repair, notice: "Repair for #{@repair.bike.serial_number} was created successfully."
    else
      @repair.repair_services.build if @repair.repair_services.empty?
      render :new, status: :unprocessable_entity
    end
  end

  def update
    photos = repair_params[:intake_photos]&.reject(&:blank?)
    attributes = repair_params.except(:intake_photos)

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

    @repair = Repair.includes(:bike, :mechanic, repair_services: :service).with_attached_intake_photos.with_rich_text_diagnosis.find(repair_id)
  end

  def repair_params
    params.expect(
      repair: [
        :bike_id,
        :mechanic_id,
        :promised_on,
        :started_on,
        :handed_back_at,
        :state,
        :diagnosis,
        intake_photos: [],
        repair_services_attributes: [
          :id,
          :service_id,
          :charged_price,
          :_destroy
        ]
      ]
    )
  end
end