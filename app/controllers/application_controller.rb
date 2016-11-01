class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def index
    @total = [
      @user_count = Count.find_by_key(:user).value || 0,
      @roundup_count = Count.find_by_key(:roundup).value || 0,
      @roundup_report_count = Count.find_by_key(:roundup_report).value || 0
    ].reduce(:+)
  end

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
