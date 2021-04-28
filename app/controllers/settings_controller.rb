class SettingsController < ApplicationController
  authorize_resource class: :setting

  def index
  end
end
