require 'rails_helper'

RSpec.describe User, type: :model do
  describe "validations" do

    it "is valid with valid attributes" do
        user = build(:user)
        expect(user).to be_valid
    end

    it "is not valid without a email" do
      user = build(:user, email: nil)
      expect(user).to_not be_valid
    end

    it "is not valid without a password" do
        user = build(:user, password: nil)
        expect(user).to_not be_valid
    end

    it "is not valid without the same password and password_confirmation" do
      user = build(:user, password: "123qwe", password_confirmation: "098poi")
      expect(user).to_not be_valid
    end

    it "is not valid with not unique email" do
        user_one = create(:user)
        user_two = build(:user, email: user_one.email)
        expect(user_two).to_not be_valid
    end
  end
end
