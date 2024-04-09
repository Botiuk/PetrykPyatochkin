require 'rails_helper'

RSpec.describe DepartmentWorker, type: :model do
  describe "validations" do
    it "is valid with valid attributes" do
        department_worker = build(:department_worker)
        expect(department_worker).to be_valid
    end

    it "is not valid without a department" do
      department_worker = build(:department_worker, department: nil)
      expect(department_worker).to_not be_valid
    end

    it "is not valid without a worker" do
        department_worker = build(:department_worker, worker: nil)
        expect(department_worker).to_not be_valid
    end

    it "is not valid without a status" do
        department_worker = build(:department_worker, status: nil)
        expect(department_worker).to_not be_valid
    end

    it "is not valid when worker is not unique" do
        department_worker_one = create(:department_worker)
        department_worker_two = build(:department_worker, worker: department_worker_one.worker)
        expect(department_worker_two).to_not be_valid
    end
  end

  describe "association" do
    it "belongs_to worker" do
      first_department_worker = create(:department_worker)
      second_department_worker = create(:department_worker)
      worker = first_department_worker.create_worker(last_name: "Smith")
      second_department_worker.worker = worker
      expect(first_department_worker.worker).to eq(worker)
      expect(second_department_worker.worker).to eq(worker)
    end

    it "belongs_to department" do
      first_department_worker = create(:department_worker)
      second_department_worker = create(:department_worker)
      department = first_department_worker.create_department(name: "Accounting")
      second_department_worker.department = department
      expect(first_department_worker.department).to eq(department)
      expect(second_department_worker.department).to eq(department)
    end
  end
end
