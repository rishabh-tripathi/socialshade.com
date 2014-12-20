class ApplicationController < ActionController::Base
  protect_from_forgery
  
  helper_method :get_user_bid
  def get_user_bid
    uid = cookies[:soclshd]        
    return uid
  end

end
