require "uri"
require "pathname"

def is_search?(request)
  params = Rack::Utils.parse_query(request.query_string)
  return params["search"].present?
end

def is_file?(request)
  url = URI.parse(request.url)
  path = Pathname.new(url.path)
  return path.extname != ""
end

def is_file_upload?(request)
  return request.request_parameters[:file].present?
end

def is_comment_upload?(request)
  return request.request_parameters[:comment].present?
end

class PageConstraint

  def self.get(request)
    if is_file?(request)
      return false
    end
    if is_search?(request)
      return false
    end
    return true
  end

  def self.post(request)
    if is_file_upload?(request)
      return false
    end
    if is_comment_upload?(request)
      return false
    end
    return true
  end

  def self.delete(request)
    if is_file?(request)
      return false
    end
    if is_comment_upload?(request)
      return false
    end
    return true
  end

  def self.matches?(request)
    if request.get?
      return self.get(request)
    end
    if request.post?
      return self.post(request)
    end
    if request.delete?
      return self.delete(request)
    end
  end
end

class SearchConstraint
  def self.matches?(request)
    return is_search?(request)
  end
end

class FileConstraint

  def self.get(request)
    return is_file?(request)
  end

  def self.post(request)
    return is_file_upload?(request)
  end

  def self.delete(request)
    return is_file?(request)
  end

  def self.matches?(request)
    if request.get?
      return self.get(request)
    end
    if request.post?
      return self.post(request)
    end
    if request.delete?
      return self.delete(request)
    end
  end
end

class CommentConstraint

  def self.post(request)
    return is_comment_upload?(request)
  end

  def self.delete(request)
    return is_comment_upload?(request)
  end

  def self.matches?(request)
    if request.post?
      return self.post(request)
    end
    if request.delete?
      return self.delete(request)
    end
  end
end

Rails.application.routes.draw do
  scope '/setting' do
    devise_for :user, controllers: {
      registrations: 'users/registrations',
      sessions: 'users/sessions'
    }


    resources :usergroups
    get "/usergroups/*id/edit/" => "usergroups#edit"
    get "/userlock" => "userlock#index"
    put "/userlock" => "userlock#update"
    get "/admin" => "admin_settings#index"
    put "/admin" => "admin_settings#update"
    get "*pages" => "settings#index"
    post "*pages" => "settings#index"
    put "*pages" => "settings#index"
    delete "*pages" => "settings#index"
    get "/" => "settings#index"
    post "/" => "settings#index"
    put "/" => "settings#index"
    delete "/" => "settings#index"
  end


  get 'rails/' =>  "application#render_404"
  get 'rails/*some' =>  "application#render_404"
  post 'rails/' =>  "application#render_404"
  post 'rails/*some' =>  "application#render_404"
  # のちに使いたいかもしれない

  root to: 'pages#show_page', constraints: PageConstraint
  get '/' => 'pages#show_search', constraints: SearchConstraint
  get '/' => 'pages#show_file', constraints: FileConstraint
  # get    '/new'        => 'pages#new'
  # get    '/edit'       => 'pages#edit'
  post   '/'           => 'pages#create_page', constraints: PageConstraint
  post   '/'           => 'pages#create_file', constraints: FileConstraint
  post   '/'           => 'pages#create_comment', constraints: CommentConstraint
  put    '/'           => 'pages#update'
  delete '/'           => 'pages#destroy_page', constraints: PageConstraint
  delete '/'           => 'pages#destroy_file', constraints: FileConstraint
  delete '/'           => 'pages#destroy_comment', constraints: CommentConstraint
  # get    '*pages/new'  => 'pages#new'
  # get    '*pages/edit' => 'pages#edit'
  get    '*pages/'     => 'pages#show_page', constraints: PageConstraint
  get    '*pages/'     => 'pages#show_search', constraints: SearchConstraint
  get    '*pages/'     => 'pages#show_file', constraints: FileConstraint
  post   '*pages/'     => 'pages#create_page', constraints: PageConstraint
  post   '*pages/'     => 'pages#create_file', constraints: FileConstraint
  post   '*pages/'     => 'pages#create_comment', constraints: CommentConstraint
  put    '*pages/'     => 'pages#update'
  delete '*pages/'     => 'pages#destroy_page', constraints: PageConstraint
  delete '*pages/'     => 'pages#destroy_file', constraints: FileConstraint
  delete '*pages/'     => 'pages#destroy_comment', constraints: CommentConstraint

  # resources :usergroups
  # devise_for :users
  # resources :user_groups
  # resources :pages
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  # root to: 'pages#index'
end
