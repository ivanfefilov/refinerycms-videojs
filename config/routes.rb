Refinery::Core::Engine.routes.draw do
  get '/system/videos/*dragonfly', :to => Dragonfly.app(:refinery_videos)

  # Frontend routes
  namespace :videos do
    resources :videos, :path => '', :only => [:index]
  end

  get 'videos/search', to: 'videos/videos#search'

  # Admin routes
  namespace :videos, :path => '' do
    namespace :admin, :path => Refinery::Core.backend_route do
      resources :videos do
        post :append_to_wym
        collection do
          post :update_positions
          get :insert
          get :dialog_preview
        end
      end
      resources :video_files, :only => [:destroy]
    end
  end

end
