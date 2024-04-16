require 'rails_helper'

RSpec.describe "WorkerPositions", type: :request do
  before :each do
    user = FactoryBot.create(:user)
    login_as(user, :scope => :user)    
  end

  it "GET new" do
    worker = FactoryBot.create(:worker)
    get new_worker_position_path(worker_id: worker.id)
    expect(response).to be_successful
  end

  it "POST create" do
    worker = FactoryBot.create(:worker)
    position = FactoryBot.create(:position)
    post worker_positions_path, params: { worker_position: FactoryBot.attributes_for(:worker_position, worker_id: worker.id, position_id: position.id) }
    expect(response).to be_redirect
    follow_redirect!
    expect(flash[:notice]).to include(I18n.t('notice.create.worker_position'))
  end

  it "GET edit" do
    worker_position = FactoryBot.create(:worker_position)
    get edit_worker_position_path(worker_position)
    expect(response).to be_successful
  end

  it "PUT update" do
    worker_position = FactoryBot.create(:worker_position)
    put worker_position_path(worker_position), params: { worker_position: {end_date: Date.today} }
    expect(worker_position.reload.end_date).to eq(Date.today)
    expect(response).to redirect_to(worker_url(worker_position.worker))
    expect(flash[:notice]).to include(I18n.t('notice.update.worker_position'))
  end

  it "GET history" do
    worker = FactoryBot.create(:worker)
    get worker_positions_history_path(worker_id: worker.id)
    expect(response).to be_successful
  end

  it "GET history with empty params worker_id" do
    get worker_positions_history_path
    expect(response).to redirect_to(workers_url)
  end

end
