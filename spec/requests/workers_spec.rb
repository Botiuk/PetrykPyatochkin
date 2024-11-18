# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Workers' do
  before do
    user = create(:user)
    login_as(user, scope: :user)
  end

  it 'GET index' do
    get workers_path
    expect(response).to be_successful
  end

  it 'GET new' do
    get new_worker_path
    expect(response).to be_successful
  end

  it 'POST create' do
    post workers_path, params: { worker: attributes_for(:worker) }
    expect(response).to be_redirect
    expect(flash[:notice]).to include(I18n.t('notice.create.worker'))
  end

  it 'GET show' do
    worker = create(:worker)
    get worker_path(worker)
    expect(response).to be_successful
  end

  it 'GET edit' do
    worker = create(:worker)
    get edit_worker_path(worker)
    expect(response).to be_successful
  end

  it 'GET edit, redirect if date_of_fired.present?' do
    worker = create(:worker, date_of_fired: Time.zone.today)
    get edit_worker_path(worker)
    expect(response).to redirect_to(worker_url(worker))
    expect(flash[:alert]).to include(I18n.t('alert.edit.fired_worker'))
  end

  it 'GET edit, redirect if he now in vacation' do
    worker = create(:worker)
    create(:vacation, worker: worker, start_date: Time.zone.today)
    get edit_worker_path(worker)
    expect(response).to redirect_to(worker_url(worker))
    expect(flash[:alert]).to include(I18n.t('alert.edit.vacation_worker'))
  end

  it 'PUT update' do
    worker = create(:worker, last_name: 'Smith')
    put worker_path(worker), params: { worker: { last_name: 'Do' } }
    expect(worker.reload.last_name).to eq('Do')
    expect(response).to redirect_to(worker_url(worker))
    expect(flash[:notice]).to include(I18n.t('notice.update.worker'))
  end

  it 'PUT update when worker fired' do
    worker = create(:worker, last_name: 'Smith')
    put worker_path(worker), params: { worker: { date_of_fired: Time.zone.today } }
    expect(worker.reload.date_of_fired).to eq(Time.zone.today)
    expect(response).to redirect_to(worker_url(worker))
    expect(flash[:notice]).to include(I18n.t('notice.update.worker_fired'))
  end

  it 'PUT update when worker fired, destroy future vacation' do
    worker = create(:worker, last_name: 'Smith')
    active_vacation = create(:vacation, worker: worker, start_date: (Time.zone.today + 1))
    put worker_path(worker), params: { worker: { date_of_fired: Time.zone.today } }
    expect { active_vacation.reload }.to raise_error(ActiveRecord::RecordNotFound)
  end

  it 'GET search' do
    get workers_search_path(last_name: 'abc')
    expect(response).to be_successful
  end

  it 'GET search with empty params last_name' do
    get workers_search_path
    expect(response).to redirect_to(workers_url)
    expect(flash[:alert]).to include(I18n.t('alert.search.worker'))
  end
end
