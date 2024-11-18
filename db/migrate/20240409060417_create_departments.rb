# frozen_string_literal: true

class CreateDepartments < ActiveRecord::Migration[7.1]
  def change
    create_table :departments do |t|
      t.string :abbreviation
      t.string :name

      t.timestamps
    end
  end
end
