class Bike < ApplicationRecord
    belongs_to :customer
    has_many :repairs, dependent: :restrict_with_error

    scope :by_brand_and_model, -> { order(:brand, :model) }

    before_validation :normalize_serial_number

    validates :serial_number, presence: true, uniqueness: true

    private

    def normalize_serial_number
        self.serial_number = serial_number.to_s.strip.upcase
    end
end