require 'rails_helper'

RSpec.describe "Workers", type: :request do

  before :each do
    user = FactoryBot.create(:user)
    login_as(user, :scope => :user)
  end

  it "GET index" do
    get workers_path
    expect(response).to be_successful
  end

  it "GET new" do
    get new_worker_path
    expect(response).to be_successful
  end

  it "POST create" do
    post workers_path, params: { worker: FactoryBot.attributes_for(:worker) }
    expect(response).to be_redirect
    expect(flash[:notice]).to include(I18n.t('notice.create.worker'))
  end

  it "GET show" do
    worker = FactoryBot.create(:worker)
    get worker_path(worker)
    expect(response).to be_successful
  end

  it "GET edit" do
    worker = FactoryBot.create(:worker)
    get edit_worker_path(worker)
    expect(response).to be_successful
  end

  it "GET edit, redirect if date_of_fired.present?" do
    worker = FactoryBot.create(:worker, date_of_fired: Date.today)
    get edit_worker_path(worker)
    expect(response).to redirect_to(workers_url)
    expect(flash[:alert]).to include(I18n.t('alert.edit.fired_worker'))
  end

  it "PUT update" do
    worker = FactoryBot.create(:worker, last_name: "Smith")
    put worker_path(worker), params: { worker: {last_name: "Do"} }
    expect(worker.reload.last_name).to eq("Do")
    expect(response).to redirect_to(worker_url(worker))
    expect(flash[:notice]).to include(I18n.t('notice.update.worker'))
  end

  it "PUT update when worker fired" do
    worker = FactoryBot.create(:worker, last_name: "Smith")
    put worker_path(worker), params: { worker: {date_of_fired: Date.today} }
    expect(worker.reload.date_of_fired).to eq(Date.today)
    expect(response).to redirect_to(worker_url(worker))
    expect(flash[:notice]).to include(I18n.t('notice.update.worker_fired'))
  end

  it "GET search" do
    get workers_search_path(last_name: "abc")
    expect(response).to be_successful
  end

  it "GET search with empty params last_name" do
    get workers_search_path
    expect(response).to redirect_to(workers_url)
    expect(flash[:alert]).to include(I18n.t('alert.search.worker'))
  end

end
