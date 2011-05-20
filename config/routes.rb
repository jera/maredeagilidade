Maredeagilidade::Application.routes.draw do

  resources :registrations do
    post 'pay', :on => :collection
    get 'pay', :on => :collection
    post 'send_email', :on => :collection
    post 'filter', :on => :collection
    get 'checkin', :on => :member
  end
  
  match 'login' => 'login#index', :as => :login
  match 'logout' => 'login#destroy', :as => :logout

  root :to => "registrations#index"
end
