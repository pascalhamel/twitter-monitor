TwitterMonitor::Application.routes.draw do

  namespace :api do
    namespace :v1 do
      resources :crowdbase_users
    end
  end
end
