class Department < ApplicationRecord
    validates :abbreviation, :name, presence: true, uniqueness: { case_sensitive: false }
end
