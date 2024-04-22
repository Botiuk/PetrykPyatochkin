class Vacation < ApplicationRecord
  belongs_to :worker

  validates :start_date, :duration_days, presence: true
end
