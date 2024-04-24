class Vacation < ApplicationRecord
  belongs_to :worker

  validates :start_date, presence: true
  validates :duration_days, presence: true, numericality: { only_integer: true, greater_than: 0 }

  before_save :calculate_end_date

  def calculate_end_date
    self.end_date = self.start_date + self.duration_days
  end

end
