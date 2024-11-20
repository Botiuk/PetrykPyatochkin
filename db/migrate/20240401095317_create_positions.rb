# frozen_string_literal: true

class CreatePositions < ActiveRecord::Migration[7.1]
  def change
    create_table :positions do |t|
      t.string :name, null: false
      t.decimal :salary, precision: 10, scale: 2, null: false
      t.integer :vacation_days, null: false

      t.timestamps
    end
    add_index :positions, 'lower(name)', unique: true
  end
end
