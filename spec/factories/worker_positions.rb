FactoryBot.define do
    factory :worker_position do
        worker { FactoryBot.create(:worker) }
        position { FactoryBot.create(:position) }
        start_date { Faker::Date.between(from: 1.year.ago, to: (Date.today-1))}
    end
end