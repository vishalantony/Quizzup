class SessionsController < ApplicationController
  def new
  end

  def create
  	user = User.find_by(email: params[:session][:email].downcase)
  	if user && user.authenticate(params[:session][:password])
      if user.activated?
    		log_in user
        remember user if params[:session][:remember_me] == '1'
    		redirect_back_or user 
        # redirects to user if the session[:forwarding_url ] is nil.
        # some pages don't allow non logged in user.
        # in those cases, the user is forwarded to the login page
        # and the intented URL is stored in the session hash.
        # once the user logs in, we see if the sessions has contains any
        # intented URL. If so, we direct the user to the intented url.
        # else we direct him to the default page, which is the user's
        # profile page.
      else
        message = "Account not yet activated. "
        message += "Check your email for activation link."
        flash[:warning] = message
        redirect_to root_url
      end
  	else
  		# create error message
  		flash.now[:danger] = "Incorrect email/password combination!"
      # flash.now sets a flash that will be available for the current action and not the next.
      # standard flash hash assignment like flash[:danger] = 'some value' sets a flash for the 
      # next action.
      # flashes disappear once the action terminates.
  		render 'new'
  	end
  end

  def destroy
  	log_out if logged_in?
  	redirect_to root_url
  end
end
