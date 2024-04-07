class WorkerPositionsController < ApplicationController
    before_action :set_worker_position, only: %i[ edit update ]
    before_action :positions_formhelper, only: %i[ new create edit ]

    def new
        @worker_position = WorkerPosition.new
        @worker = Worker.find(params[:worker_id])
    end

    def create
        @worker_position = WorkerPosition.new(worker_position_params)
        @worker = Worker.find(@worker_position.worker_id)
        if @worker_position.save            
            redirect_to worker_url(@worker), notice: t('notice.create.worker_position')
        else
            render :new, status: :unprocessable_entity
        end
    end

    def edit
        @worker = Worker.find(params[:worker_id])
    end

    def update
        @worker = Worker.find(@worker_position.worker_id)
        if @worker_position.update(worker_position_params)            
            redirect_to worker_url(@worker), notice: t('notice.update.worker_position')
        else
            render :edit, status: :unprocessable_entity
        end
    end

    private

    def set_worker_position
        @worker_position = WorkerPosition.find(params[:id])
    rescue ActiveRecord::RecordNotFound
        redirect_to workers_url
    end

    def positions_formhelper
        @positions = Position.order(:name).pluck(:name, :id)
    end

    def worker_position_params
        params.require(:worker_position).permit(:worker_id, :position_id, :start_date, :end_date)
    end

end
