# frozen_string_literal: true

class CreateDepartments < ActiveRecord::Migration[7.1]
  def change
    create_table :departments do |t|
      t.string :abbreviation, null: false
      t.string :name, null: false

      t.timestamps
    end
    add_index :departments, 'lower(abbreviation)', unique: true
    add_index :departments, 'lower(name)', unique: true
  end
end
