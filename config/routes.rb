Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  get 'main/index', to: 'main#index'
  get 'workers/search', to: 'workers#search'
  get 'worker_positions/history', to: 'worker_positions#history'
  get 'vacations/history', to: 'vacations#history'

  resources :workers, except: :destroy
  resources :positions, except: :destroy
  resources :worker_positions, except: [:index, :show, :destroy]
  resources :departments
  resources :department_workers, except: [:index, :show]
  resources :vacations, except: :index

  # Defines the root path route ("/")
  root "main#index"

  match '*unmatched', to: 'application#page_not_found', via: :all
end
