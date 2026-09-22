class Service < ApplicationRecord
    has_many :repair_services, dependent: :restrict_with_error
    has_many :repairs, through: :repair_services, dependent: :restrict_with_error

    scope :by_name, -> { order(:name) }

    validates :name, presence: true, uniqueness: true
    validates :price, presence: true, numericality: { greater_than: 0 }

    before_validation :normalize_name

    private

    def normalize_name
        self.name = name.to_s.strip
    end
end