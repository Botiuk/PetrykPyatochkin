require 'rails_helper'

RSpec.describe "Positions", type: :request do

  before :each do
    user = FactoryBot.create(:user)
    login_as(user, :scope => :user)
  end

  it "GET index" do
    get positions_path
    expect(response).to be_successful
  end

  it "GET new" do
    get new_position_path
    expect(response).to be_successful
  end

  it "POST create" do
    post positions_path, params: { position: FactoryBot.attributes_for(:position) }
    expect(response).to be_redirect
    follow_redirect!
    expect(flash[:notice]).to include(I18n.t('notice.create.position'))
  end

  it "GET show" do
    position = FactoryBot.create(:position)
    get position_path(position)
    expect(response).to be_successful
  end

  it "GET edit" do
    position = FactoryBot.create(:position)
    get edit_position_path(position)
    expect(response).to be_successful
  end

  it "PUT update" do
    position = FactoryBot.create(:position, vacation_days: 21)
    put position_path(position), params: { position: {vacation_days: 30} }
    expect(position.reload.vacation_days).to eq(30)
    expect(response).to redirect_to(position_url(position))
    expect(flash[:notice]).to include(I18n.t('notice.update.position'))
  end
end
