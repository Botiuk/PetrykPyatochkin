require 'rails_helper'

RSpec.describe "Vacations", type: :request do
  before :each do
    user = FactoryBot.create(:user)
    login_as(user, :scope => :user)
  end

  it "GET new" do
    worker = FactoryBot.create(:worker)
    worker_position = FactoryBot.create(:worker_position, worker_id: worker.id)
    department_worker = FactoryBot.create(:department_worker, worker_id: worker.id)
    get new_vacation_path(worker_id: worker.id)
    expect(response).to be_successful
  end

  it "GET new when worker used all vacation days" do
    worker = FactoryBot.create(:worker)
    worker_position = FactoryBot.create(:worker_position, worker_id: worker.id)
    department_worker = FactoryBot.create(:department_worker, worker_id: worker.id)
    vacation = FactoryBot.create(:vacation, worker_id: worker.id, duration_days: worker_position.position.vacation_days, start_date: Date.today.beginning_of_year)
    get new_vacation_path(worker_id: worker.id)
    expect(response).to redirect_to(worker_url(worker))
    expect(flash[:alert]).to include(I18n.t('alert.new.vacation'))
  end

  it "GET new when worker has not yet any positions" do
    worker = FactoryBot.create(:worker)
    get new_vacation_path(worker_id: worker.id)
    expect(response).to redirect_to(worker_url(worker))
    expect(flash[:alert]).to include(I18n.t('alert.new.vacation_position'))
  end

  it "GET new when worker has not active position" do
    worker = FactoryBot.create(:worker)
    worker_position = FactoryBot.create(:worker_position, worker_id: worker.id, end_date: Date.today)
    get new_vacation_path(worker_id: worker.id)
    expect(response).to redirect_to(worker_url(worker))
    expect(flash[:alert]).to include(I18n.t('alert.new.vacation_position'))
  end

  it "GET new when worker has not department" do
    worker = FactoryBot.create(:worker)
    worker_position = FactoryBot.create(:worker_position, worker_id: worker.id)
    get new_vacation_path(worker_id: worker.id)
    expect(response).to redirect_to(worker_url(worker))
    expect(flash[:alert]).to include(I18n.t('alert.new.vacation_department'))
  end

  it "GET new when worker has active vacation" do
    worker = FactoryBot.create(:worker)
    worker_position = FactoryBot.create(:worker_position, worker_id: worker.id)
    department_worker = FactoryBot.create(:department_worker, worker_id: worker.id)
    vacation = FactoryBot.create(:vacation, worker_id: worker.id, duration_days: (worker_position.position.vacation_days - 5), start_date: (Date.today + 3) )
    get new_vacation_path(worker_id: worker.id)
    expect(response).to redirect_to(worker_url(worker))
    expect(flash[:alert]).to include(I18n.t('alert.new.vacation_active'))
  end

  it "POST create" do
    worker = FactoryBot.create(:worker)
    department_worker = FactoryBot.create(:department_worker, worker_id: worker.id)
    post vacations_path, params: { vacation: FactoryBot.attributes_for(:vacation, worker_id: worker.id) }
    expect(response).to be_redirect
    expect(flash[:notice]).to include(I18n.t('notice.create.vacation'))
  end

  it "POST create when 5 colleagues in vacation" do
    worker = FactoryBot.create(:worker)
    department = FactoryBot.create(:department)
    department_worker = FactoryBot.create(:department_worker, worker_id: worker.id, department_id: department.id)
    5.times do
      department_worker = FactoryBot.create(:department_worker, department_id: department.id)
      vacation = FactoryBot.create(:vacation, worker_id: department_worker.worker_id, start_date: Date.today)
    end
    post vacations_path, params: { vacation: FactoryBot.attributes_for(:vacation, worker_id: worker.id, start_date: Date.today) }
    expect(response).to redirect_to(department_url(department))
    expect(flash[:alert]).to include(I18n.t('alert.create.vacation'))
  end

  it "GET show" do
    vacation = FactoryBot.create(:vacation)
    get vacation_path(vacation)
    expect(response).to be_successful
  end

  it "GET edit" do
    worker = FactoryBot.create(:worker)
    worker_position = FactoryBot.create(:worker_position, worker_id: worker.id)
    vacation = FactoryBot.create(:vacation, worker_id: worker.id, start_date: Date.today)
    get edit_vacation_path(vacation)
    expect(response).to be_successful
  end

  it "GET edit when end_date passt" do
    worker = FactoryBot.create(:worker)
    worker_position = FactoryBot.create(:worker_position, worker_id: worker.id)
    vacation = FactoryBot.create(:vacation, worker_id: worker.id, start_date: 2.month.ago)
    get edit_vacation_path(vacation)
    expect(response).to redirect_to(vacation_url(vacation))
    expect(flash[:alert]).to include(I18n.t('alert.edit.vacation'))
  end

  it "PUT update" do
    vacation = FactoryBot.create(:vacation)
    put vacation_path(vacation), params: { vacation: {duration_days: (vacation.duration_days - 1)} }
    expect(response).to redirect_to(vacation_url(vacation))
    expect(flash[:notice]).to include(I18n.t('notice.update.vacation'))
  end

  it "DELETE destroy" do
    worker = FactoryBot.create(:worker)
    vacation = FactoryBot.create(:vacation, worker_id: worker.id, start_date: Date.today.next_week)
    delete vacation_path(vacation)
    expect(response).to redirect_to(worker_url(worker))
    expect(flash[:notice]).to include(I18n.t('notice.destroy.vacation'))
  end

  it "DELETE destroy when vacation start" do
    worker = FactoryBot.create(:worker)
    vacation = FactoryBot.create(:vacation, worker_id: worker.id, start_date: Date.today)
    delete vacation_path(vacation)
    expect(response).to redirect_to(worker_url(worker))
    expect(flash[:alert]).to include(I18n.t('alert.destroy.vacation'))
  end

  it "GET history" do
    worker = FactoryBot.create(:worker)
    get vacations_history_path(worker_id: worker.id)
    expect(response).to be_successful
  end

  it "GET history with empty params worker_id" do
    get vacations_history_path
    expect(response).to redirect_to(workers_url)
  end
end
