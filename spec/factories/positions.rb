# frozen_string_literal: true

FactoryBot.define do
  factory :position do
    name { Faker::Job.position + Faker::Number.unique.number(digits: 4).to_s }
    salary { Faker::Number.decimal(l_digits: 5, r_digits: 2) }
    vacation_days { Faker::Number.between(from: 20, to: 30) }
  end
end
