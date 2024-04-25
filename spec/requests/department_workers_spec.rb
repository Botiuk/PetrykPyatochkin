require 'rails_helper'

RSpec.describe "DepartmentWorkers", type: :request do
  before :each do
    user = FactoryBot.create(:user)
    login_as(user, :scope => :user)    
  end

  it "GET new" do
    get new_department_worker_path
    expect(response).to be_successful
  end

  it "GET new with params worker_id, worker_position present and active" do
    worker = FactoryBot.create(:worker)
    worker_position = FactoryBot.create(:worker_position, worker: worker)
    get new_department_worker_path(worker_id: worker.id)
    expect(response).to be_successful
  end

  it "GET new with params worker_id, worker_position not active" do
    worker = FactoryBot.create(:worker)
    worker_position = FactoryBot.create(:worker_position, worker: worker, end_date: (Date.today - 1))
    get new_department_worker_path(worker_id: worker.id)
    expect(response).to redirect_to(new_worker_position_url(worker_id: worker.id))
    expect(flash[:alert]).to include(I18n.t('alert.create.department_worker_position'))
  end

  it "GET new with params worker_id, worker_positions blank" do
    worker = FactoryBot.create(:worker)
    get new_department_worker_path(worker_id: worker.id)
    expect(response).to redirect_to(new_worker_position_url(worker_id: worker.id))
    expect(flash[:alert]).to include(I18n.t('alert.create.department_worker_position'))
  end

  it "GET new with params department_id" do
    department = FactoryBot.create(:department)
    get new_department_worker_path(department_id: department.id)
    expect(response).to be_successful
  end

  it "POST create" do
    worker = FactoryBot.create(:worker)
    department = FactoryBot.create(:department)
    post department_workers_path, params: { department_worker: FactoryBot.attributes_for(:department_worker, worker_id: worker.id, department_id: department.id) }
    expect(response).to redirect_to(worker_url(worker))
    expect(flash[:notice]).to include(I18n.t('notice.create.department_worker'))
  end

  it "POST create when department has 20 workers" do
    worker = FactoryBot.create(:worker)
    department = FactoryBot.create(:department)
    20.times do
      department_worker = FactoryBot.create(:department_worker, department_id: department.id)
    end
    post department_workers_path, params: { department_worker: FactoryBot.attributes_for(:department_worker, worker_id: worker.id, department_id: department.id) }
    expect(response).to redirect_to(new_department_worker_url(worker_id: worker.id, department_id: department.id, status: "worker"))
    expect(flash[:alert]).to include(I18n.t('alert.new.department_worker'))
  end

  it "POST create manager when department has manager" do
    worker = FactoryBot.create(:worker)
    department = FactoryBot.create(:department)
    department_worker = FactoryBot.create(:department_worker, department_id: department.id, status: "manager")
    post department_workers_path, params: { department_worker: FactoryBot.attributes_for(:department_worker, worker_id: worker.id, department_id: department.id, status: "manager") }
    expect(response).to redirect_to(new_department_worker_url(worker_id: worker.id, department_id: department.id, status: "manager"))
    expect(flash[:alert]).to include(I18n.t('alert.new.department_worker_manager_present'))
  end

  it "GET edit" do
    department_worker = FactoryBot.create(:department_worker)
    get edit_department_worker_path(department_worker)
    expect(response).to be_successful
  end

  it "GET edit when manager present and departmetn_worker.worker is manager" do
    department_worker = FactoryBot.create(:department_worker, status: "manager")
    get edit_department_worker_path(department_worker)
    expect(response).to be_successful
  end

  it "GET edit when manager present and departmetn_worker.worker is not manager" do
    department = FactoryBot.create(:department)
    department_worker_one = FactoryBot.create(:department_worker, department_id: department.id, status: "manager")
    department_worker_two = FactoryBot.create(:department_worker, department_id: department.id)
    get edit_department_worker_path(department_worker_two)
    expect(response).to redirect_to(department_url(department))
    expect(flash[:alert]).to include(I18n.t('alert.new.department_worker_manager_present'))
  end

  it "PUT update" do
    department_worker = FactoryBot.create(:department_worker)
    put department_worker_path(department_worker), params: { department_worker: {status: "manager"} }
    expect(department_worker.reload.status).to eq("manager")
    expect(response).to redirect_to(department_url(department_worker.department))
    expect(flash[:notice]).to include(I18n.t('notice.update.department_worker'))
  end

  it "DELETE destroy" do
    worker = FactoryBot.create(:worker)
    department_worker = FactoryBot.create(:department_worker, worker: worker)
    delete department_worker_path(department_worker)
    expect(response).to redirect_to(worker_url(worker))
    expect(flash[:notice]).to include(I18n.t('notice.destroy.department_worker'))
  end
end
