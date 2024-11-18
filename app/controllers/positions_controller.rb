# frozen_string_literal: true

class PositionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_position, only: %i[show edit update]

  def index
    @pagy, @positions = pagy(Position.order(:name), items: 20)
  end

  def show; end

  def new
    @position = Position.new
  end

  def edit; end

  def create
    @position = Position.new(position_params)
    if @position.save
      redirect_to position_url(@position), notice: t('notice.create.position')
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @position.update(position_params)
      redirect_to position_url(@position), notice: t('notice.update.position')
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_position
    @position = Position.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to positions_url
  end

  def position_params
    params.require(:position).permit(:name, :salary, :vacation_days)
  end
end
