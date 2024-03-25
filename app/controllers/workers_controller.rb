class WorkersController < ApplicationController
    before_action :set_worker, only: %i[ show edit update ]

    def index
        @workers = Worker.all
    end

    def show
    end

    def new
        @worker = Worker.new
    end

    def create
        @worker = Worker.new(worker_params)
        if @worker.save
            redirect_to worker_url(@worker), notice: t('notice.create.worker')
        else
            render :new, status: :unprocessable_entity
        end
    end

    def edit
    end

    def update
        if @worker.update(worker_params)
            redirect_to worker_url(@worker), notice: t('notice.update.worker')
        else
            render :edit, status: :unprocessable_entity
        end
    end

    private

    def set_worker
        @worker = Worker.find(params[:id])
    rescue ActiveRecord::RecordNotFound
        redirect_to workers_url
    end

    def worker_params
        params.require(:worker).permit(:roll_number, :last_name, :first_name, :middle_name, :passport, :date_of_birth, :place_of_birth, :home_adress, :date_of_hired, :date_of_fired)
    end

end