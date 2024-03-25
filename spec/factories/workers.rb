FactoryBot.define do
    factory :worker do
        roll_number { Faker::Alphanumeric.unique.alphanumeric(number: 10, min_alpha: 3, min_numeric: 3) }
        last_name { Faker::Name.last_name }
        first_name { Faker::Name.first_name }
        middle_name { Faker::Name.middle_name }
        passport { Faker::Code.unique.nric }
        date_of_birth { Faker::Date.between(from: 64.year.ago, to: 19.year.ago) }
        place_of_birth { Faker::Address.city }
        home_adress { Faker::Address.full_address }
        date_of_hired { Faker::Date.between(from: 1.year.ago, to: (Date.today-1))}
    end
end