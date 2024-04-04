require 'rails_helper'

RSpec.describe WorkerPosition, type: :model do
  describe "validations" do
    it "is valid with valid attributes" do
        worker_position = build(:worker_position, end_date: Date.today)
        expect(worker_position).to be_valid
    end

    it "is valid without end_date" do
        worker_position = build(:worker_position)
        expect(worker_position).to be_valid
    end

    it "is not valid without a worker" do
        worker_position = build(:worker_position, worker: nil)
        expect(worker_position).to_not be_valid
    end

    it "is not valid without a psition" do
        worker_position = build(:worker_position, position: nil)
        expect(worker_position).to_not be_valid
    end

    it "is not valid without a start_date" do
        worker_position = build(:worker_position, start_date: nil)
        expect(worker_position).to_not be_valid
    end

    it "is not valid when start_date is greater than end_date" do
        worker_position = build(:worker_position, start_date: Date.today, end_date: (Date.today-1))
        expect(worker_position).to_not be_valid
    end

    it "is valid when start_date is equal end_date" do
        worker_position = build(:worker_position, start_date: Date.today, end_date: Date.today)
        expect(worker_position).to be_valid
    end
  end

  describe "association" do

    it "belongs_to worker" do
      first_worker_position = create(:worker_position)
      second_worker_position = create(:worker_position)
      worker = first_worker_position.create_worker(last_name: "Smith")
      second_worker_position.worker = worker
      expect(first_worker_position.worker).to eq(worker)
      expect(second_worker_position.worker).to eq(worker)
    end

    it "belongs_to position" do
      first_worker_position = create(:worker_position)
      second_worker_position = create(:worker_position)
      position = first_worker_position.create_position(name: "Admin")
      second_worker_position.position = position
      expect(first_worker_position.position).to eq(position)
      expect(second_worker_position.position).to eq(position)
    end
  end

end
