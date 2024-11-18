# frozen_string_literal: true

FactoryBot.define do
  factory :worker_position do
    worker { FactoryBot.create(:worker) }
    position { FactoryBot.create(:position) }
    start_date { Faker::Date.between(from: 1.year.ago, to: (Time.zone.today - 1)) }
  end
end
