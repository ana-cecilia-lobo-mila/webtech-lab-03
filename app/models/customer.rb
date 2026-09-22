class Customer < ApplicationRecord
    has_many :bikes, dependent: :restrict_with_error
    has_many :repairs, through: :bikes, dependent: :restrict_with_error

    scope :by_name, -> { order(:name) }

    validates :name, presence: true

    before_validation :normalize_name

    private

    def normalize_name
        self.name = name.to_s.strip
    end
end