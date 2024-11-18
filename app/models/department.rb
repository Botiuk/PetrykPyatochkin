# frozen_string_literal: true

class Department < ApplicationRecord
  has_many :department_workers, dependent: :destroy

  validates :abbreviation, :name, presence: true, uniqueness: { case_sensitive: false }
end
