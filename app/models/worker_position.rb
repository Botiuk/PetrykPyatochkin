class WorkerPosition < ApplicationRecord
  belongs_to :worker
  belongs_to :position

  validates :start_date, presence: true
  validates :end_date, comparison: { greater_than_or_equal_to: :start_date }, allow_blank: true
end
