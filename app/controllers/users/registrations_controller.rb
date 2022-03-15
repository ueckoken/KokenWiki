# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  layout "settings", only: [:edit]

  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]
  # GET /resource/sign_up
  def new
    super
  end

  # POST /resource
  def create
    token = params[:user][:invitation_token]

    if User.count != 0
      if token.blank?
        redirect_to new_registration_path(:user), alert: "Invitation token required"
        return
      end

      invitation_token = InvitationToken.find_by(token: token)

      if invitation_token.nil?
        redirect_to new_registration_path(:user), alert: "Invalid invitation token"
        return
      elsif invitation_token.expired?
        redirect_to new_registration_path(:user, t: invitation_token), alert: "Invitation token expired"
        return
      end
    end

    build_resource(sign_up_params)

    if resource.save
      yield resource if block_given?
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_flashing_format?
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)

        # 独自の処理を追加

        userparam = params[:user]

        createuser = User.find_by(email: userparam[:email])
        # 一人目の登録はadminに設定,2人目からは登録時にロックする
        if User.count == 1
          createuser.update(is_admin: true)
        end
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_flashing_format?
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      respond_with resource
    end
  end
  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
