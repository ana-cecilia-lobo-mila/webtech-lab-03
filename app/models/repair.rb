class Repair < ApplicationRecord
    belongs_to :bike
    belongs_to :mechanic, optional: true
    has_many_attached :intake_photos do |attachable|
        attachable.variant :thumbnail, resize_to_fill: [120, 90]
        attachable.variant :display, resize_to_limit: [800, 600]
    end

    has_rich_text :diagnosis

    has_many :repair_services, dependent: :destroy
    has_many :services, through: :repair_services
    accepts_nested_attributes_for :repair_services, allow_destroy: true, reject_if: ->(attributes) { attributes["service_id"].blank? }

    enum :state, {
        received: "received",
        diagnosing: "diagnosing",
        waiting_for_approval: "waiting_for_approval",
        approved: "approved",
        rejected: "rejected",
        in_repair: "in_repair",
        ready: "ready",
        picked_up: "picked_up"
    }

    scope :newest_first, -> { order(created_at: :desc) }
    scope :by_promised_on, -> { order(promised_on: :asc) }
    scope :open, -> { where(handed_back_at: nil) }
    scope :overdue, -> { open.where("promised_on < ?", Date.current) }

    def overdue?
        handed_back_at.nil? && promised_on.present? && promised_on < Date.current
    end

    def total
        repair_services.sum(:charged_price)
    end

    validates :promised_on, presence: true
    validates :state, presence: true

    validate :dates_are_consistent
    validate :handback_and_customer_response_are_consistent
    validate :state_transition_is_valid
    validate :intake_photos_have_valid_content_type
    validate :intake_photos_are_within_size_limit

    private

    def dates_are_consistent
        if started_on.present? && promised_on.present? && promised_on < started_on
            errors.add(:promised_on, "cannot be earlier than the repair start date")
        end

        return if handed_back_at.blank?

        if started_on.present? && handed_back_at.present? && handed_back_at.to_date < started_on
            errors.add(:handed_back_at, "cannot be earlier than the repair start date")
        end
    end

    def handback_and_customer_response_are_consistent
        if handed_back_at.present? && !rejected? && !picked_up?
            errors.add(:handed_back_at, "can only be recorded after the repair has been handed back"
            )
        end

        if (rejected? || picked_up?) && handed_back_at.nil?
            errors.add(:handed_back_at, "must be recorded after the repair has been handed back"
            )
        end
    end

    def state_transition_is_valid
        return if new_record?
        return if state.blank? || state_in_database.blank?
        return if state == state_in_database

        allowed_transitions = {
            received: [:diagnosing],
            diagnosing: [:waiting_for_approval],
            waiting_for_approval: [:approved, :rejected],
            approved: [:in_repair],
            in_repair: [:ready],
            ready: [:picked_up],
            rejected: [:picked_up],
            picked_up: []
        }

        previous_state = state_in_database.to_sym
        next_state = state.to_sym


        if allowed_transitions[previous_state].blank? || !allowed_transitions[previous_state].include?(next_state)
            errors.add(:state, "is not a valid transition")
        end
    end

    def intake_photos_have_valid_content_type
        allowed_types = ["image/jpeg", "image/png"]

        intake_photos.each do |photo|
            next if allowed_types.include?(photo.blob.content_type)

            errors.add(:intake_photos, "#{photo.filename} must be a JPEG or PNG image")
        end
    end

    def intake_photos_are_within_size_limit
        max_size = 5.megabytes

        intake_photos.each do |photo|
            next if photo.blob.byte_size <= max_size

            errors.add(:intake_photos, "#{photo.filename} is too large (maximum size is 5 MB)"
            )
        end
    end
end