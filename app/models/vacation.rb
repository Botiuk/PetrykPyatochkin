# frozen_string_literal: true

class Vacation < ApplicationRecord
  belongs_to :worker

  validates :start_date, presence: true
  validates :duration_days, presence: true, numericality: { only_integer: true, greater_than: 0 }

  before_save :calculate_end_date

  def calculate_end_date
    self.end_date = start_date + duration_days
  end

  def self.worker_used_vacations_days(position_vacation_days, worker_id)
    position_vacation_days - Vacation.where('EXTRACT(year FROM start_date) = ? AND worker_id = ?', Time.zone.today.year,
                                            worker_id).where.not('end_date > ?', Time.zone.today).sum(:duration_days)
  end

  def self.worker_free_vacations_days(position_vacation_days, worker_id)
    position_vacation_days - Vacation.where('EXTRACT(year FROM start_date) = ? AND worker_id = ?', Time.zone.today.year,
                                            worker_id).sum(:duration_days)
  end

  def self.colleaques_in_vacation_count(colleagues_ids, start_date, end_date)
    Vacation.where(worker_id: colleagues_ids).where.not(end_date: ...Time.zone.today).where.not(
      'start_date > ? OR end_date < ?', end_date, start_date
    ).count
  end

  def self.active_vacation(worker_id)
    Vacation.where(worker_id: worker_id).where.not(end_date: ...Time.zone.today).first
  end
end
