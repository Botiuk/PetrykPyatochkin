require 'rails_helper'

RSpec.describe Department, type: :model do
  describe "validations" do
    it "is valid with valid attributes" do
      department = build(:department)
      expect(department).to be_valid
    end

    it "is not valid without a abbreviation" do
      department = build(:department, abbreviation: nil)
      expect(department).to_not be_valid
    end

    it "is not valid without a name" do
      department = build(:department, name: nil)
      expect(department).to_not be_valid
    end

    it "is not valid with not unique abbreviation" do
      department_one = create(:department)
      department_two = build(:department, abbreviation: department_one.abbreviation)
      expect(department_two).to_not be_valid
    end

    it "is not valid with not unique abbreviation, false case sensitive " do
      department_one = create(:department, abbreviation: "Acc")
      department_two = build(:department, abbreviation: "ACC")
      expect(department_two).to_not be_valid
    end

    it "is not valid with not unique name" do
      department_one = create(:department)
      department_two = build(:department, name: department_one.name)
      expect(department_two).to_not be_valid
    end

    it "is not valid with not unique name, false case sensitive " do
      department_one = create(:department, name: "Accounting")
      department_two = build(:department, name: "ACCOUNTING")
      expect(department_two).to_not be_valid
    end
  end

end
