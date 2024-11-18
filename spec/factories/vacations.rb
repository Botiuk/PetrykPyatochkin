# frozen_string_literal: true

FactoryBot.define do
  factory :vacation do
    worker { FactoryBot.create(:worker) }
    start_date { Faker::Date.between(from: 1.year.ago, to: Time.zone.today) }
    duration_days { Faker::Number.between(from: 20, to: 30) }
  end
end
