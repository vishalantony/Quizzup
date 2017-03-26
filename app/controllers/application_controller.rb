class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  def hello
  	render html: "hello, world!"
  end

  def time_diff_in_minutes(time1, time2) 
  	time3 = (time1 - time2).to_i.abs / 60
  end

  def logged_in_user
    unless logged_in?
      flash[:danger] = "Please log in."
      store_location
      redirect_to login_url
    end
  end

end
