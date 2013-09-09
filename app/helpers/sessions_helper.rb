module SessionsHelper

  
  def sign_in(user)
    cookies.permanent[:remember_token] = user.remember_token
    # The purpose of this line is to create current_user, accessible in both controllers and views
    self.current_user = user
  end

  def current_user=(user)
    @current_user = user
  end 

  def current_user
    @current_user ||= User.find_by_remember_token(cookies[:remember_token])
  end 

  def current_user?(user)
    user == current_user
  end

  def signed_in? 
  	!current_user.nil?
  end

  def sign_out 
    self.current_user = nil
    cookies.delete(:remember_token)
  end

  def store_location
    session[:return_to] = request.fullpath 
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end

  # Direct users who are not logged-in to sign-in page
  def signed_in_user
    unless signed_in?
      store_location
      redirect_to signin_path, notice:"Whoops! Looks like you need to sign in."
    end
  end  
end
