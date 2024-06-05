class ApplicationController < ActionController::Base
  protect_from_forgery

  before_action :check_signed_in

  helper_method :current_user, :user_signed_in?

  def current_user
    return @current_user if defined?(@current_user)

    @current_user = session[:user_address].nil? ? nil : User.find_by(address: session[:user_address])
  end

  def user_signed_in?
    !current_user.nil?
  end

  protected

  def check_signed_in
    return if user_signed_in?

    respond_to do |format|
      format.html { redirect_to new_sessions_path }
      format.js {
        render js: "window.location.href='#{new_sessions_path}'"
      }
    end
  end
end
