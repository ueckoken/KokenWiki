require "uri"
require "pathname"

def is_file?(request)
  parsable_url = WEBrick::HTTPUtils.escape(CGI.unescape(request.url))
  url = URI.parse(parsable_url)
  path = Pathname.new(url.path)
  return path.extname != ""
end

def is_file_upload?(request)
  return request.request_parameters[:file].present?
end

def is_comment_upload?(request)
  return request.request_parameters[:comment].present?
end

def is_rails_predefined_routes?(request)
  return request.path.start_with?("/rails/")
end

class PageConstraint
  def self.get(request)
    if is_file?(request)
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
    if is_rails_predefined_routes?(request)
      return false
    end
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
    if is_rails_predefined_routes?(request)
      return false
    end
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
    if is_rails_predefined_routes?(request)
      return false
    end
    if request.post?
      return self.post(request)
    end
    if request.delete?
      return self.delete(request)
    end
  end
end

Rails.application.routes.draw do
  scope "/setting" do
    devise_for :user, controllers: {
      registrations: "users/registrations",
      sessions: "users/sessions"
    }

    resources :invitation_tokens, only: [:index, :create, :destroy]
    resources :usergroups
    get "/users" => "users#index"
    post "/users/:user_id/privilege" => "userprivileges#create", as: :user_privilege
    post "/users/:user_id/unprivilege" => "userprivileges#delete", as: :user_unprivilege
    post "/users/:user_id/lock" => "userlocks#create", as: :user_lock
    post "/users/:user_id/unlock" => "userlocks#delete", as: :user_unlock
    get "/" => redirect("/setting/user/edit")
  end


  root to: "pages#show_page", constraints: PageConstraint
  get "/" => "files#show", constraints: FileConstraint

  get "/search" => "pages#show_search"

  # get    '/new'        => 'pages#new'
  # get    '/edit'       => 'pages#edit'
  post   "/"           => "pages#create", constraints: PageConstraint
  post   "/"           => "files#create", constraints: FileConstraint
  post   "/"           => "comments#create", constraints: CommentConstraint
  put    "/"           => "pages#update"
  delete "/"           => "pages#destroy", constraints: PageConstraint
  delete "/"           => "files#destroy", constraints: FileConstraint
  delete "/"           => "comments#destroy", constraints: CommentConstraint
  # get    '*pages/new'  => 'pages#new'
  # get    '*pages/edit' => 'pages#edit'
  get    "*pages/"     => "pages#show_page", constraints: PageConstraint
  get    "*pages/"     => "files#show", constraints: FileConstraint
  post   "*pages/"     => "pages#create", constraints: PageConstraint
  post   "*pages/"     => "files#create", constraints: FileConstraint
  post   "*pages/"     => "comments#create", constraints: CommentConstraint
  put    "*pages/"     => "pages#update"
  delete "*pages/"     => "pages#destroy", constraints: PageConstraint
  delete "*pages/"     => "files#destroy", constraints: FileConstraint
  delete "*pages/"     => "comments#destroy", constraints: CommentConstraint

  # resources :usergroups
  # devise_for :users
  # resources :user_groups
  # resources :pages
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  # root to: 'pages#index'
end
