# frozen_string_literal: true

class AddEndDateToVacations < ActiveRecord::Migration[7.1]
  def change
    add_column :vacations, :end_date, :date
  end
end
