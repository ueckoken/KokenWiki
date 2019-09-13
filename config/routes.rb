Rails.application.routes.draw do

  scope '/setting' do
    devise_for :user, :controllers =>{
      :registrations => 'user/registrations',
      :sessions => 'user/sessions'
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

    
  root to: 'pages#index' 
  get    '/new'        => 'pages#new'
  get    '/edit'       => 'pages#edit'
  post   '/'           => 'pages#create'
  put    '/'           => 'pages#update'
  delete '/'           => 'pages#destroy'
  #get    '*pages/new'  => 'pages#new'
  #get    '*pages/edit' => 'pages#edit'
  get    '*pages/'      => 'pages#index'
  post   '*pages/'      => 'pages#create'
  put    '*pages/'      => 'pages#update'
  delete '*pages/'      => 'pages#destroy'
  end
  #resources :usergroups
  #devise_for :users
  #resources :user_groups
  #resources :pages
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  #root to: 'pages#index'

end
