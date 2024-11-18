# frozen_string_literal: true

class WorkerPositionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_worker_position, only: %i[edit update]
  before_action :positions_formhelper, only: %i[new create edit]

  def new
    @worker_position = WorkerPosition.new
    @worker = Worker.find(params[:worker_id])
  rescue ActiveRecord::RecordNotFound
    redirect_to workers_url
  end

  def edit; end

  def create
    @worker_position = WorkerPosition.new(worker_position_params)
    @worker = Worker.find(@worker_position.worker_id)
    if @worker_position.save
      only_create_worker_position_or_also_add_to_department
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @worker = Worker.find(@worker_position.worker_id)
    if @worker_position.update(worker_position_params)
      if @worker_position.end_date.present?
        redirect_to new_worker_position_url(worker_id: @worker.id), notice: t('notice.update.worker_position')
      else
        redirect_to edit_worker_position_url(@worker_position), alert: t('alert.edit.end_date')
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def history
    @worker_positions = WorkerPosition.where(worker_id: params[:worker_id]).order(:start_date)
    @worker = Worker.find(params[:worker_id])
  rescue ActiveRecord::RecordNotFound
    redirect_to workers_url
  end

  private

  def only_create_worker_position_or_also_add_to_department
    department_worker = DepartmentWorker.where(worker_id: @worker.id).first
    if department_worker.present?
      redirect_to worker_url(@worker), notice: t('notice.create.worker_position_change')
    else
      redirect_to new_department_worker_url(worker_id: @worker.id), notice: t('notice.create.worker_position')
    end
  end

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
