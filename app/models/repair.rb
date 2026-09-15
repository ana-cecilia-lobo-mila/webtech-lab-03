class Repair < ApplicationRecord
    belongs_to :bike
    belongs_to :mechanic
    has_many :repair_services
end