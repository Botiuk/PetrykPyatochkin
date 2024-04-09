class DepartmentsController < ApplicationController
  before_action :set_department, only: %i[ show edit update destroy ]

    def index
        @pagy, @departments = pagy(Department.all.order(:name), items: 20)
    rescue Pagy::OverflowError
        redirect_to departments_url(page: 1)
    end

    def show
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
