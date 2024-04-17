class WorkersController < ApplicationController
    before_action :set_worker, only: %i[ show edit update ]

    def index
        @pagy, @workers = pagy(Worker.all, items: 20)
    end

    def show
        @worker_position = WorkerPosition.where(worker_id: @worker.id).last
        @worker_department = Department.joins(:department_workers).where(department_workers: {worker_id: @worker.id}).first
        unless @worker.date_of_fired.present? || @worker_position.blank? || @worker_position.end_date.present?
            @salary = Position.where(id: @worker_position.position_id).pluck(:salary).join.to_f
            @worker_salary =  (@salary * (1.012 ** ((Date.today - @worker.date_of_hired) / 365).floor)).round(2)
        end
    end

    def new
        @worker = Worker.new
    end

    def create
        @worker = Worker.new(worker_params)
        if @worker.save
            redirect_to new_worker_position_url(worker_id: @worker.id), notice: t('notice.create.worker')
        else
            render :new, status: :unprocessable_entity
        end
    end

    def edit
        if @worker.date_of_fired.present?
            redirect_to workers_url, alert: t('alert.edit.fired_worker')
        end
    end

    def update
        if @worker.update(worker_params)
            if @worker.date_of_fired.present?
                department_worker = DepartmentWorker.where(worker_id: @worker.id).first
                department_worker.destroy if department_worker.present?
                redirect_to worker_url(@worker), notice: t('notice.update.worker_fired')
            else
                redirect_to worker_url(@worker), notice: t('notice.update.worker')
            end            
        else
            render :edit, status: :unprocessable_entity
        end
    end

    def search
        if params[:last_name].blank?
          redirect_to workers_url, alert: t('alert.search.worker')
        else
          @pagy, @workers = pagy(Worker.where('lower(last_name) LIKE ?', "%" + params[:last_name].downcase + "%"), items: 20)
          @search_params = params[:last_name]
        end
    rescue Pagy::OverflowError
        redirect_to workers_url(page: 1)
    end

    private

    def set_worker
        @worker = Worker.find(params[:id])
    rescue ActiveRecord::RecordNotFound
        redirect_to workers_url
    end

    def worker_params
        params.require(:worker).permit(:roll_number, :last_name, :first_name, :middle_name, :passport, :date_of_birth, :place_of_birth, :home_adress, :date_of_hired, :date_of_fired, :worker_photo)
    end

end
