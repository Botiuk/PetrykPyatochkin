# frozen_string_literal: true

class MainController < ApplicationController
  def index
    departments_with_managers = DepartmentWorker.where(status: 'manager').pluck(:department_id)
    @departments_without_managers = Department.where.not(id: departments_with_managers)
    department_workers_ids = DepartmentWorker.pluck(:worker_id)
    @workers_without_department = Worker.where.not(id: department_workers_ids).where(date_of_fired: [nil, ''])
    @birthday_workers = Worker.birthday
    @anniversary_workers = Worker.anniversary
  end
end
