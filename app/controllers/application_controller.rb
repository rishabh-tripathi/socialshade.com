class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :set_uid, :get_browser

  def set_uid
    @uid = get_user_bid
  end

  def get_browser
    @mobile = false
    if(request.env['HTTP_USER_AGENT'].present?)
      user_agent = request.env['HTTP_USER_AGENT'].downcase
      # if(request.env['HTTP_USER_AGENT'] =~ /Mobile|webOS|Android|Tablet|iphone|ipod/)
      if(request.env['HTTP_USER_AGENT'] =~ /Mobile|webOS|Android|iphone|ipod/)
        @mobile = true        
      end
      # Making webview defaulat for ipad
      if(request.env['HTTP_USER_AGENT'] =~ /iPad|Tablet/)
        @mobile = false        
      end
    end 
  end
  
  helper_method :get_user_bid
  def get_user_bid
    uid = cookies[:soclshd]        
    return uid
  end    

end
