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

        it "is not valid when a salary is not a number" do
            position = build(:position, salary: "kfjkf2343")
            expect(position).to_not be_valid
        end

        it "is not valid when a salary is < 0" do
            position = build(:position, salary: -8)
            expect(position).to_not be_valid
        end

        it "is not valid when a vacation_days is not a number" do
            position = build(:position, vacation_days: "kfjkf2343")
            expect(position).to_not be_valid
        end

        it "is not valid when a vacation_days is not integer" do
            position = build(:position, vacation_days: 1.2)
            expect(position).to_not be_valid
        end

        it "is not valid when a vacation_days is < 0" do
            position = build(:position, vacation_days: -18)
            expect(position).to_not be_valid
        end
    end

    describe "association" do
        it "has_many worker_position" do
            position = create(:position)
            first_worker_position = create(:worker_position)
            second_worker_position = create(:worker_position)
            position.worker_positions << [first_worker_position, second_worker_position]
            expect(position.worker_positions.first).to eq(first_worker_position)
            expect(position.worker_positions.second).to eq(second_worker_position)
        end
    end

end
