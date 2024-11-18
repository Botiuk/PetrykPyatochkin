# frozen_string_literal: true

class CreateWorkerPositions < ActiveRecord::Migration[7.1]
  def change
    create_table :worker_positions do |t|
      t.references :worker, null: false, foreign_key: true
      t.references :position, null: false, foreign_key: true
      t.date :start_date
      t.date :end_date

      t.timestamps
    end
  end
end
