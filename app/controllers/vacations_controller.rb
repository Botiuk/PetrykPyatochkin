# frozen_string_literal: true

class VacationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_vacation, only: %i[show edit update destroy]

  def show
    @worker = Worker.find(@vacation.worker_id)
  end

  def new
    find_worker
    if @worker.vacations.present? && @worker.vacations.last.end_date > Time.zone.today
      redirect_to worker_url(@worker), alert: t('alert.new.vacation_active')
    elsif @worker.active_worker?
      worker_can_go_to_vacation
    elsif @worker.worker_positions.blank? || @worker.worker_positions.last.end_date.present?
      redirect_to worker_url(@worker), alert: t('alert.new.vacation_position')
    else
      redirect_to worker_url(@worker), alert: t('alert.new.vacation_department')
    end
  end

  def edit
    if @vacation.end_date > Time.zone.today
      @worker = Worker.find(@vacation.worker_id)
      @vacation_days = Vacation.worker_used_vacations_days(@worker.positions.last.vacation_days, @worker.id)
      @vacation_pased_days = (Time.zone.today - @vacation.start_date).to_i if Time.zone.today > @vacation.start_date
    else
      redirect_to vacation_url(@vacation), alert: t('alert.edit.vacation')
    end
  end

  def create
    @vacation = Vacation.new(vacation_params)
    workers_colleagues_vacations
    if @colleagues_in_vacation_count <= 4
      if @vacation.save
        redirect_to vacation_url(@vacation), notice: t('notice.create.vacation')
      else
        render :new, status: :unprocessable_entity
      end
    else
      redirect_to department_url(@department), alert: t('alert.create.vacation')
    end
  end

  def update
    if @vacation.update(vacation_params)
      redirect_to vacation_url(@vacation), notice: t('notice.update.vacation')
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @worker = Worker.find(@vacation.worker_id)
    if @vacation.start_date > Time.zone.today
      @vacation.destroy
      redirect_to worker_url(@worker), notice: t('notice.destroy.vacation')
    else
      redirect_to worker_url(@worker), alert: t('alert.destroy.vacation')
    end
  end

  def history
    @vacations = Vacation.where(worker_id: params[:worker_id])
    @worker = Worker.find(params[:worker_id])
  rescue ActiveRecord::RecordNotFound
    redirect_to workers_url
  end

  private

  def find_worker
    @worker = Worker.find(params[:worker_id])
  rescue ActiveRecord::RecordNotFound
    redirect_to workers_url
  end

  def worker_can_go_to_vacation
    @vacation_days = Vacation.worker_free_vacations_days(@worker.positions.last.vacation_days, @worker.id)
    if @vacation_days.positive?
      @vacation = Vacation.new
    else
      redirect_to worker_url(@worker), alert: t('alert.new.vacation')
    end
  end

  def workers_colleagues_vacations
    @vacation.end_date = @vacation.start_date + @vacation.duration_days
    @department = Department.find(@vacation.worker.department.id)
    @colleagues_ids = DepartmentWorker.where(department_id: @department.id).pluck(:worker_id)
    @colleagues_in_vacation_count = Vacation.colleaques_in_vacation_count(@colleagues_ids, @vacation.start_date,
                                                                          @vacation.end_date)
  end

  def set_vacation
    @vacation = Vacation.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to workers_url
  end

  def vacation_params
    params.require(:vacation).permit(:worker_id, :start_date, :duration_days, :end_date)
  end
end
