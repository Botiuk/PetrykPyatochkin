# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Departments' do
  before do
    user = create(:user)
    login_as(user, scope: :user)
  end

  it 'GET index' do
    get departments_path
    expect(response).to be_successful
  end

  it 'GET new' do
    get new_department_path
    expect(response).to be_successful
  end

  it 'POST create' do
    post departments_path, params: { department: attributes_for(:department) }
    expect(response).to be_redirect
    follow_redirect!
    expect(flash[:notice]).to include(I18n.t('notice.create.department'))
  end

  it 'GET show' do
    department = create(:department)
    get department_path(department)
    expect(response).to be_successful
  end

  it 'GET edit' do
    department = create(:department)
    get edit_department_path(department)
    expect(response).to be_successful
  end

  it 'PUT update' do
    department = create(:department, abbreviation: 'abcd')
    put department_path(department), params: { department: { abbreviation: 'wxyz' } }
    expect(department.reload.abbreviation).to eq('wxyz')
    expect(response).to redirect_to(department_url(department))
    expect(flash[:notice]).to include(I18n.t('notice.update.department'))
  end

  it 'DELETE destroy' do
    department = create(:department)
    delete department_path(department)
    expect(response).to redirect_to(departments_url)
    expect(flash[:notice]).to include(I18n.t('notice.destroy.department'))
  end
end
