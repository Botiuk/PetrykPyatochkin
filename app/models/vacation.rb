class Vacation < ApplicationRecord
  belongs_to :worker

  validates :start_date, :duration_days, presence: true
  validates :end_date, comparison: { greater_than: :start_date }, allow_blank: true
end
