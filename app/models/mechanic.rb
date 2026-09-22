class Mechanic < ApplicationRecord
    has_many :repairs, dependent: :restrict_with_error

    scope :by_name, -> { order(:name) }

    validates :name, presence: true

    before_validation :normalize_name

    private

    def normalize_name
        self.name = name.to_s.strip
    end
end