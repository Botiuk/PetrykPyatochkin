class DepartmentsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_department, only: %i[ show edit update destroy ]

    def index
        @pagy, @departments = pagy(Department.all.order(:name), items: 20)
        @department_workers_count = DepartmentWorker.all.group(:department_id).count        
        @department_workers_managers = Worker.find_departments_managers
    rescue Pagy::OverflowError
        redirect_to departments_url(page: 1)
    end

    def show
        department_workers_ids = DepartmentWorker.where(department_id: @department.id).pluck(:worker_id)
        @workers = Worker.where(id: department_workers_ids)
        @department_manager = Worker.joins(:department_worker).where(department_worker: {department_id: @department.id, status: "manager"}).first
        @active_vacations = Vacation.where(worker_id: department_workers_ids).where.not('end_date < ?', Date.today)
        @worker_id_active_positions = WorkerPosition.where(worker_id: department_workers_ids, end_date: nil).pluck(:worker_id)
    end

    def new
        @department = Department.new
    end

    def create
        @department = Department.new(department_params)
        if @department.save
            redirect_to department_url(@department), notice: t('notice.create.department')
        else
            render :new, status: :unprocessable_entity
        end
    end

    def edit
    end

    def update
        if @department.update(department_params)
            redirect_to department_url(@department), notice: t('notice.update.department')
        else
            render :edit, status: :unprocessable_entity
        end
    end

    def destroy
        @department.destroy
        redirect_to departments_url, notice: t('notice.destroy.department')
    end

    private

    def set_department
        @department = Department.find(params[:id])
    rescue ActiveRecord::RecordNotFound
        redirect_to departments_url
    end

    def department_params
        params.require(:department).permit(:abbreviation, :name)
    end
end
