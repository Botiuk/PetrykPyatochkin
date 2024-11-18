# frozen_string_literal: true

class MainController < ApplicationController
  def index
    departments_with_managers = DepartmentWorker.where(status: 'manager').pluck(:department_id)
    @departments_without_managers = Department.where.not(id: departments_with_managers)
    @birthday_workers = Worker.birthday
    @anniversary_workers = Worker.anniversary
  end
end
