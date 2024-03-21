class Worker < ApplicationRecord
    validates :roll_number, presence: true, uniqueness: { case_sensitive: false }
    validates :last_name, :first_name, :middle_name, :passport, :date_of_birth, :place_of_birth, :home_adress, :date_of_hired, presence: true
    validates :date_if_fired, comparison: { greater_than_or_equal_to: :date_of_hired }, allow_blank: true

    validates_each :last_name, :first_name, :middle_name do |record, attr, value|
        record.errors.add(attr, 'First letter must be upper') if /\A[[:lower:]]/.match?(value)
    end
end
