CurateNd::Application.routes.draw do

  mount_roboto
  mount Orcid::Engine => "/orcid"
  Blacklight.add_routes(self)
  HydraHead.add_routes(self)

  root 'static_pages#home'

  # Some ETDs are not loading correctly on the curation concern page
  get '/concern/etds/new', to: 'curation_concern/etds#new'
  get '/concern/etds/:id', to: redirect { |params, request|
    "/show/#{params[:id]}"
  }
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

    constraints CurateND::AdminAccessTokenConstraint do
      resources :temporary_access_tokens, path: 'access_tokens'
    end
  end

  scope :admin do
    constraints CurateND::AdminConstraint do
      curate_repo_manager_permissions
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
  get 'contribute', to: 'static_pages#contribute'
  get 'faqs',  to: 'static_pages#faqs'
  get 'orcid_settings', to: 'user_profiles#orcid_settings'
  get 'policies', to: 'static_pages#policies'
  get 'policies/:policyname', to: 'static_pages#policies', as: :named_policy
  get '500', to: 'static_pages#error'
  get '502', to: 'static_pages#error', default: { status_code: '502' }
  get '404', to: 'static_pages#error', default: { status_code: '404' }
  get '422', to: 'static_pages#error', default: { status_code: '422' }
  get '413', to: 'static_pages#error', default: { status_code: '413' }

end
