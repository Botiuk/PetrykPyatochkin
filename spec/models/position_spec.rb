require 'rails_helper'

RSpec.describe Position, type: :model do
  describe "validations" do
    it "is valid with valid attributes" do
        position = build(:position)
        expect(position).to be_valid
    end

    it "is not valid without a name" do
        position = build(:position, name: nil)
        expect(position).to_not be_valid
    end

    it "is not valid without a salary" do
        position = build(:position, salary: nil)
        expect(position).to_not be_valid
    end

    it "is not valid without a vacation_days" do
        position = build(:position, vacation_days: nil)
        expect(position).to_not be_valid
    end  

    it "is not valid with not unique name" do
        position_one = create(:position)
        position_two = build(:position, name: position_one.name)
        expect(position_two).to_not be_valid
    end

    it "is not valid with not unique name, false case sensitive " do
        position_one = create(:position, name: "Developer")
        position_two = build(:position, name: "DEVELOPER")
        expect(position_two).to_not be_valid
    end
  end
  
end
