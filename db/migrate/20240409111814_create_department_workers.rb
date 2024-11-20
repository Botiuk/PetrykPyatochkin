# frozen_string_literal: true

class CreateDepartmentWorkers < ActiveRecord::Migration[7.1]
  def change
    create_table :department_workers do |t|
      t.references :department, null: false, foreign_key: true
      t.references :worker, null: false, foreign_key: true, index: { unique: true }
      t.integer :status

      t.timestamps
    end
  end
end
