class Position < ApplicationRecord    
    validates :name, presence: true, uniqueness: { case_sensitive: false }
    validates :salary, :vacation_days, presence: true
end
