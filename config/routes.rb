CurateNd::Application.routes.draw do
  mount_roboto
  mount Orcid::Engine => "/orcid"
  Blacklight.add_routes(self)
  HydraHead.add_routes(self)

  root 'static_pages#home'

  curate_for

  namespace :admin do
    constraints CurateND::AdminConstraint do
      get '/', to: 'base#index'

      mount Harbinger::Engine, at: 'harbinger'
      mount Resque::Server, :at => "queues"
      resources :announcements
      resources :accounts, only: [:show, :index] do
        collection { get :start_masquerading }
        member { delete :disconnect_orcid_profile}
      end
    end
    constraints CurateND::AdminAPIConstraint do
      post "reindex", to: "reindex#reindex"
      post "add_to_collection", to: "add_to_collection#submit"
    end
  end

  # Due to an apparent bug in devise the following routes should be presented
  # in this order
  scope :admin do
    constraints CurateND::AdminConstraint do
      devise_for :users, controllers: { masquerades: 'admin/masquerades'}, only: :masquerades
    end
  end

  delete 'dismiss_announcement/:id', to: 'admin/announcements#dismiss', as: 'dismiss_announcement'

  devise_scope :user do
    get 'dashboard', to: 'catalog#index', as: :user_root
    get 'admin/accounts/stop_masquerading', to: 'admin/masquerades#back', as: 'stop_masquerading'
  end

  devise_for :users, controllers: { sessions: :sessions, registrations: :registrations, omniauth_callbacks: 'devise/multi_auth/omniauth_callbacks' }, skip: :masquerades

  #NOTE: This action may not be welcoming for new users.
  get 'get_started', to: 'classify_concerns#new'

  get 'about', to: 'static_pages#about'
  get 'beta',  to: redirect('/')
  get 'faqs',  to: 'static_pages#faqs'
  get '500', to: 'static_pages#error'
  get '502', to: 'static_pages#error', default: { status_code: '502' }
  get '404', to: 'static_pages#error', default: { status_code: '404' }
  get '422', to: 'static_pages#error', default: { status_code: '422' }
  get '413', to: 'static_pages#error', default: { status_code: '413' }
  get 'orcid_settings', to: 'user_profiles#orcid_settings'

end
