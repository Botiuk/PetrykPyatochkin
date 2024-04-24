require 'rails_helper'

RSpec.describe Vacation, type: :model do
  describe "validations" do
    it "is valid with valid attributes" do
        vacation = build(:vacation)
        expect(vacation).to be_valid
    end

    it "is not valid without a worker" do
        vacation = build(:vacation, worker: nil)
        expect(vacation).to_not be_valid
    end

    it "is not valid without a start_date" do
        vacation = build(:vacation, start_date: nil)
        expect(vacation).to_not be_valid
    end

    it "is not valid without a duration_days" do
        vacation = build(:vacation, duration_days: nil)
        expect(vacation).to_not be_valid
    end

    it "is not valid when a duration_days is less than 1" do
      vacation = build(:vacation, duration_days: 0)
      expect(vacation).to_not be_valid
    end

    it "is not valid when a duration_days is not number" do
      vacation = build(:vacation, duration_days: "Two")
      expect(vacation).to_not be_valid
    end

    it "is not valid when a duration_days is not integer" do
      vacation = build(:vacation, duration_days: 1.5)
      expect(vacation).to_not be_valid
    end
  end

  describe "association" do
    it "belongs_to worker" do
      first_worker_vacation = create(:vacation)
      second_worker_vacation = create(:vacation)
      worker = first_worker_vacation.create_worker(last_name: "Smith")
      second_worker_vacation.worker = worker
      expect(first_worker_vacation.worker).to eq(worker)
      expect(second_worker_vacation.worker).to eq(worker)
    end
  end

  describe "calculate_end_date" do
    it "before_save" do
        vacation = build(:vacation)
        expect(vacation).to be_valid
        expect(vacation.end_date).to eq(nil)
        vacation.save
        expect(vacation.end_date).to eq(vacation.start_date + vacation.duration_days)
    end
  end

end
