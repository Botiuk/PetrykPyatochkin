FactoryBot.define do
    factory :position do
        name { Faker::Job.unique.position }
        salary { Faker::Number.decimal(l_digits: 5, r_digits: 2) }
        vacation_days { Faker::Number.between(from: 20, to: 30) }    
    end
end