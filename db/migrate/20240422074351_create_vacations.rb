# frozen_string_literal: true

class CreateVacations < ActiveRecord::Migration[7.1]
  def change
    create_table :vacations do |t|
      t.references :worker, null: false, foreign_key: true
      t.date :start_date
      t.integer :duration_days

      t.timestamps
    end
  end
end
