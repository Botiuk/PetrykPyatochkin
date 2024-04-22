FactoryBot.define do
    factory :vacation do
        worker { FactoryBot.create(:worker) }
        start_date { Faker::Date.between(from: 1.year.ago, to: Date.today)}
        duration_days { Faker::Number.between(from: 20, to: 30) } 
    end
end