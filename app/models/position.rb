# frozen_string_literal: true

class Position < ApplicationRecord
  has_many :worker_positions, dependent: nil
  has_many :positions, through: :workers, dependent: nil

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :salary, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :vacation_days, presence: true, numericality: { greater_than_or_equal_to: 0, only_integer: true }
end
