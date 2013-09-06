CurateNd::Application.routes.draw do
  root 'welcome#index'
  Blacklight.add_routes(self)
  HydraHead.add_routes(self)

  devise_for :users, controllers: { sessions: :sessions, registrations: :registrations }

  devise_scope :users do
    get 'dashboard', to: 'dashboard#index', as: :user_root
  end

  curate_for containers: [:senior_theses, :datasets, :articles]

  resources :users, only: [:update, :show, :edit]

  namespace :admin do
    constraints CurateND::AdminConstraint do
      mount Resque::Server, :at => "queues"
    end
  end

end
