FactoryBot.define do
    factory :department do
        abbreviation { Faker::Alphanumeric.unique.alphanumeric(number: 4, min_alpha: 4)}
        name { Faker::Company.department + Faker::Number.unique.number(digits: 4).to_s }          
    end
end