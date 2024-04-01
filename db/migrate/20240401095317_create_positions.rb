class CreatePositions < ActiveRecord::Migration[7.1]
  def change
    create_table :positions do |t|
      t.string :name
      t.decimal :salary, precision: 10, scale: 2
      t.integer :vacation_days

      t.timestamps
    end
  end
end
