# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'WorkerPositions' do
  before do
    user = create(:user)
    login_as(user, scope: :user)
  end

  it 'GET new' do
    worker = create(:worker)
    get new_worker_position_path(worker_id: worker.id)
    expect(response).to be_successful
  end

  it 'POST create' do
    worker = create(:worker)
    position = create(:position)
    post worker_positions_path,
         params: { worker_position: attributes_for(:worker_position, worker_id: worker.id, position_id: position.id) }
    expect(response).to redirect_to(new_department_worker_url(worker_id: worker.id))
    expect(flash[:notice]).to include(I18n.t('notice.create.worker_position'))
  end

  it 'POST create when worker has department_worker' do
    worker = create(:worker)
    position = create(:position)
    create(:department_worker, worker: worker)
    post worker_positions_path,
         params: { worker_position: attributes_for(:worker_position, worker_id: worker.id, position_id: position.id) }
    expect(response).to redirect_to(worker_url(worker))
    expect(flash[:notice]).to include(I18n.t('notice.create.worker_position_change'))
  end

  it 'GET edit' do
    worker_position = create(:worker_position)
    get edit_worker_position_path(worker_position)
    expect(response).to be_successful
  end

  it 'PUT update' do
    worker_position = create(:worker_position)
    put worker_position_path(worker_position), params: { worker_position: { worker_id: worker_position.worker.id } }
    expect(response).to redirect_to(edit_worker_position_url(worker_position))
    expect(flash[:alert]).to include(I18n.t('alert.edit.end_date'))
  end

  it 'PUT update with end_date' do
    worker_position = create(:worker_position)
    put worker_position_path(worker_position), params: { worker_position: { end_date: Time.zone.today } }
    expect(worker_position.reload.end_date).to eq(Time.zone.today)
    expect(response).to redirect_to(new_worker_position_url(worker_id: worker_position.worker.id))
    expect(flash[:notice]).to include(I18n.t('notice.update.worker_position'))
  end

  it 'GET history' do
    worker = create(:worker)
    get worker_positions_history_path(worker_id: worker.id)
    expect(response).to be_successful
  end

  it 'GET history with empty params worker_id' do
    get worker_positions_history_path
    expect(response).to redirect_to(workers_url)
  end
end
