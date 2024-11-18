# frozen_string_literal: true

FactoryBot.define do
  factory :worker do
    roll_number { Faker::Number.unique.within(range: 1..10_000) }
    last_name { Faker::Name.last_name }
    first_name { Faker::Name.first_name }
    middle_name { Faker::Name.middle_name }
    passport { Faker::Code.unique.nric }
    date_of_birth { Faker::Date.between(from: 64.years.ago, to: 19.years.ago) }
    place_of_birth { Faker::Address.city }
    home_adress { Faker::Address.full_address }
    date_of_hired { Faker::Date.between(from: 1.year.ago, to: (Time.zone.today - 1)) }
  end
end
