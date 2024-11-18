# frozen_string_literal: true

FactoryBot.define do
  factory :department_worker do
    department { FactoryBot.create(:department) }
    worker { FactoryBot.create(:worker) }
    status { 'worker' }
  end
end
