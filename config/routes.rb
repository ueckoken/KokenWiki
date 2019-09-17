Rails.application.routes.draw do

  scope '/setting' do
    devise_for :user, :controllers =>{
      :registrations => 'users/registrations',
      :sessions => 'users/sessions'
    }

    
    resources :usergroups
    get "/usergroups/*id/edit/" => "usergroups#edit"
    get "/userlock" => "userlock#index"
    put "/userlock" => "userlock#update"
    get "/admin" => "admin_setting#index"
    put "/admin" => "admin_setting#update"
    get "*pages" => "settings#index"
    post "*pages" => "settings#index"
    put "*pages" => "settings#index"
    delete "*pages" => "settings#index"
    get "/" => "settings#index"
    post "/" => "settings#index"
    put "/" => "settings#index"
    delete "/" => "settings#index"

  end
  root to: 'pages#show_route' 
  get    '/new'        => 'pages#new'
  get    '/edit'       => 'pages#edit'
  post   '/'           => 'pages#create'
  put    '/'           => 'pages#update'
  delete '/'           => 'pages#destroy'
  #get    '*pages/new'  => 'pages#new'
  #get    '*pages/edit' => 'pages#edit'
  get    '*pages/'      => 'pages#show_route'
  post   '*pages/'      => 'pages#create'
  put    '*pages/'      => 'pages#update'
  delete '*pages/'      => 'pages#destroy'

  #resources :usergroups
  #devise_for :users
  #resources :user_groups
  #resources :pages
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  #root to: 'pages#index'

end
