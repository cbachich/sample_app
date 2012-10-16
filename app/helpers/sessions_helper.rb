module SessionsHelper

  # Sets the cookes to remain permanent for this user token
  # If we wanted to set a time frame for it to expire, we could use this:
  # cookies[:remember_token] = { value: user.remember_token,
  #                              expires: 20.years.from_now.utc
  def sign_in(user)
    cookies.permanent[:remember_token] = user.remember_token
    self.current_user = user
  end

  # Returns if the user is signed in
  def signed_in?
    !current_user.nil?
  end

  # Is used as a way to define current_user = user
  def current_user=(user)
    @current_user = user
  end

  def signed_in_user
    unless signed_in?
      store_location
      redirect_to signin_path, notice: "Please sign in."
    end
  end

  # Uses the ||= to look in the database for the remember token if current user
  # is empty. If it's not empty, it doesn't do the search
  def current_user
    @current_user ||= User.find_by_remember_token(cookies[:remember_token])
  end

  def current_user?(user)
    user == current_user
  end

  # Sign out the user by deleting their cookie
  def sign_out
    self.current_user = nil
    cookies.delete(:remember_token)
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end

  def store_location
    session[:return_to] = request.fullpath
  end
end
