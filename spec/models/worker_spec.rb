# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Worker do
  describe 'validations' do
    it 'is valid with valid attributes' do
      worker = build(:worker, date_of_fired: Time.zone.today)
      expect(worker).to be_valid
    end

    it 'is valid without date_of_fired' do
      worker = build(:worker)
      expect(worker).to be_valid
    end

    it 'is not valid without a roll_number' do
      worker = build(:worker, roll_number: nil)
      expect(worker).not_to be_valid
    end

    it 'is not valid without a last_name' do
      worker = build(:worker, last_name: nil)
      expect(worker).not_to be_valid
    end

    it 'is not valid without a first_name' do
      worker = build(:worker, first_name: nil)
      expect(worker).not_to be_valid
    end

    it 'is not valid without a middle_name' do
      worker = build(:worker, middle_name: nil)
      expect(worker).not_to be_valid
    end

    it 'is not valid without a passport' do
      worker = build(:worker, passport: nil)
      expect(worker).not_to be_valid
    end

    it 'is not valid without a date_of_birth' do
      worker = build(:worker, date_of_birth: nil)
      expect(worker).not_to be_valid
    end

    it 'is not valid without a place_of_birth' do
      worker = build(:worker, place_of_birth: nil)
      expect(worker).not_to be_valid
    end

    it 'is not valid without a home_adress' do
      worker = build(:worker, home_adress: nil)
      expect(worker).not_to be_valid
    end

    it 'is not valid without a date_of_hired' do
      worker = build(:worker, date_of_hired: nil)
      expect(worker).not_to be_valid
    end

    it 'is not valid with a small first letter in last_name' do
      worker = build(:worker, last_name: 'ericson')
      expect(worker).not_to be_valid
    end

    it 'is not valid with a small first letter in first_name' do
      worker = build(:worker, first_name: 'sven')
      expect(worker).not_to be_valid
    end

    it 'is not valid with a small first letter in middle_name' do
      worker = build(:worker, middle_name: 'goran')
      expect(worker).not_to be_valid
    end

    it 'is not valid with not unique roll_number' do
      worker_one = create(:worker)
      worker_two = build(:worker, roll_number: worker_one.roll_number)
      expect(worker_two).not_to be_valid
    end

    it 'is not valid with not unique roll_number, false case sensitive' do
      create(:worker, roll_number: 'abc123')
      worker_two = build(:worker, roll_number: 'ABC123')
      expect(worker_two).not_to be_valid
    end

    it 'is not valid when date_of_hired is greater than date_of_fired' do
      worker = build(:worker, date_of_hired: Time.zone.today, date_of_fired: (Time.zone.today - 1))
      expect(worker).not_to be_valid
    end

    it 'is valid when date_of_fired is equal date_of_hired' do
      worker = build(:worker, date_of_hired: Time.zone.today, date_of_fired: Time.zone.today)
      expect(worker).to be_valid
    end
  end

  describe 'association' do
    it 'has_many worker_position' do
      worker = create(:worker)
      first_worker_position = create(:worker_position)
      second_worker_position = create(:worker_position)
      worker.worker_positions << [first_worker_position, second_worker_position]
      expect(worker.worker_positions.unscoped.first).to eq(first_worker_position)
      expect(worker.worker_positions.unscoped.second).to eq(second_worker_position)
    end
  end
end
