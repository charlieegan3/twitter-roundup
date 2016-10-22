class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def authorize
    if current_user.nil?
	  flash[:warning] = "You need to login first"
      redirect_to root_path
	end
  end

  def current_user
      @current_user ||= User.find_by(id: session[:user_id])
  end

  helper_method :current_user
end
