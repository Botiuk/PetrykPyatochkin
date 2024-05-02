class DepartmentWorkersController < ApplicationController
    before_action :set_department_worker, only: %i[ edit update destroy ]
    before_action :my_formhelper, only: %i[ new create ]

    def new
        @department_worker = DepartmentWorker.new
        if params[:worker_id].present?
            @worker = Worker.find(params[:worker_id]) 
            if @worker.worker_positions.blank? || @worker.worker_positions.last.end_date.present?
                redirect_to new_worker_position_url(worker_id: @worker.id), alert: t('alert.create.department_worker_position')
            end
        end
        @department = Department.find(params[:department_id]) if params[:department_id].present?
    end

    def create
        @department_worker = DepartmentWorker.new(department_worker_params)
        @manager = DepartmentWorker.where(department_id: @department_worker.department_id, status: "manager")
        @department_worker_count = DepartmentWorker.where(department_id: @department_worker.department_id).pluck(:id).count
        unless @manager.present? && @department_worker.status == "manager"
            if @department_worker_count <= 19
                if @department_worker.save
                    redirect_to worker_url(@department_worker.worker), notice: t('notice.create.department_worker')
                else
                    render :new, status: :unprocessable_entity
                end
            else
                redirect_to new_department_worker_path(department_worker_params), alert: t('alert.new.department_worker')
            end
        else
            redirect_to new_department_worker_path(department_worker_params), alert: t('alert.new.department_worker_manager_present')
        end
    end

    def edit
        @manager = DepartmentWorker.where(department_id: @department_worker.department_id, status: "manager").first
        if @manager.present? && @department_worker.worker_id != @manager.worker_id
            redirect_to department_url(@department_worker.department), alert: t('alert.new.department_worker_manager_present')
        end
    end

    def update
        @department = Department.find(@department_worker.department_id)
        if @department_worker.update(department_worker_params)
            redirect_to department_url(@department), notice: t('notice.update.department_worker')
        else
            render :edit, status: :unprocessable_entity
        end
    end

    def destroy
        @worker = Worker.find(@department_worker.worker_id)
        @department_worker.destroy
        active_vacation = Vacation.active_vacation(@department_worker.worker_id)
        if active_vacation.present? && active_vacation.start_date <= Date.today && active_vacation.end_date >= Date.today
            active_vacation.update(duration_days: (Date.today - active_vacation.start_date).to_i, end_date: Date.today)
        end
        if active_vacation.present? && active_vacation.start_date > Date.today
            active_vacation.destroy
        end
        redirect_to worker_url(@worker), notice: t('notice.destroy.department_worker')
    end

    private

    def set_department_worker
        @department_worker = DepartmentWorker.find(params[:id])
    rescue ActiveRecord::RecordNotFound
        redirect_to workers_url
    end

    def my_formhelper
        @departments = Department.order(:name).pluck(:name, :id)
        busy_workers = DepartmentWorker.pluck(:worker_id)
        worker_active_position = WorkerPosition.where(end_date: nil).pluck(:worker_id)
        @free_workers = Worker.unscoped.where(date_of_fired: [nil, ""], id: worker_active_position).where.not(id: busy_workers).order(:roll_number).pluck(:roll_number, :id)
    end

    def department_worker_params
        params.require(:department_worker).permit(:department_id, :worker_id, :status)
    end
end
