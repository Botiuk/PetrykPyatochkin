# frozen_string_literal: true

class CreateWorkers < ActiveRecord::Migration[7.1]
  def change
    create_table :workers do |t|
      t.integer :roll_number, null: false
      t.string :last_name, null: false
      t.string :first_name, null: false
      t.string :middle_name, null: false
      t.string :passport, null: false
      t.date :date_of_birth, null: false
      t.text :place_of_birth, null: false
      t.text :home_adress, null: false
      t.date :date_of_hired, null: false
      t.date :date_of_fired

      t.timestamps
    end
    add_index :workers, :roll_number, unique: true
  end
end
