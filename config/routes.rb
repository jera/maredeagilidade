Maredeagilidade::Application.routes.draw do

  resources :registrations do
    post 'pay', :on => :collection
    get 'pay', :on => :collection
  end
  
  match 'login' => 'login#index', :as => :login
  match 'logout' => 'login#destroy', :as => :logout

  root :to => "registrations#index"
end
