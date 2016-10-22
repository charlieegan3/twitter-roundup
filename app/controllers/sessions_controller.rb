class SessionsController < ApplicationController
  def create
	begin
      auth_hash = request.env['omniauth.auth']
      @user = User.find_or_create_by(
        username: auth_hash['info']['nickname'],
        uid: auth_hash['uid'],
        provider: 'twitter'
      )
	  session[:user_id] = @user.id
	  flash[:success] = "Welcome, #{@user.username}!"
	rescue
	  flash[:warning] = "There was an error while trying to authenticate you..."
	end
	redirect_to root_path
  end

  def destroy
    if current_user
      session.delete(:user_id)
      flash[:success] = 'Logged out'
    end
    redirect_to root_path
  end
end
