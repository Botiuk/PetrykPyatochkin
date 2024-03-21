class CreateWorkers < ActiveRecord::Migration[7.1]
  def change
    create_table :workers do |t|
      t.integer :roll_number
      t.string :last_name
      t.string :first_name
      t.string :middle_name
      t.string :passport
      t.date :date_of_birth
      t.text :place_of_birth
      t.text :home_adress
      t.date :date_of_hired
      t.date :date_of_fired

      t.timestamps
    end
  end
end
