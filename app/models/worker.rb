class Worker < ApplicationRecord
    has_many :worker_positions
    has_one :department_worker
    has_one :department, through: :department_worker
    has_many :positions, through: :worker_positions
    
    has_one_attached :worker_photo

    validates :roll_number, presence: true, uniqueness: { case_sensitive: false }
    validates :last_name, :first_name, :middle_name, :passport, :date_of_birth, :place_of_birth, :home_adress, :date_of_hired, presence: true
    validates :date_of_fired, comparison: { greater_than_or_equal_to: :date_of_hired }, allow_blank: true

    validates_each :last_name, :first_name, :middle_name do |record, attr, value|
        record.errors.add(attr, I18n.t('errors.messages.first_letter')) if /\A[[:lower:]]/.match?(value)
    end

    default_scope { order(:last_name, :first_name, :middle_name, :date_of_birth) }

    private

    def self.find_departments_managers
        managers = DepartmentWorker.where(status: "manager").pluck(:department_id, :worker_id)
        managers.map do |element|
            element[1] = Worker.where(id: element[1]).pluck(:last_name, :first_name, :middle_name).join(" ")
        end
        managers.to_h
    end

    def self.birthday
        Worker.where('EXTRACT(month FROM date_of_birth) = ? AND EXTRACT(day FROM date_of_birth) = ?', Date.today.month, Date.today.day).where(date_of_fired: [nil, ""])
    end

    def self.anniversary
        Worker.where('EXTRACT(month FROM date_of_hired) = ? AND EXTRACT(day FROM date_of_hired) = ?', Date.today.month, Date.today.day).where(date_of_fired: [nil, ""]).where.not(date_of_hired: Date.today)
    end

end
