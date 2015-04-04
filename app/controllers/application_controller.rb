class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :set_uid, :get_browser

  def set_uid
    if(params[:muid].present?)
      @uid = params[:muid]
    else
      @uid = get_user_bid    
      if(!@uid.present? && params[:uid].present?)
        @uid = params[:uid]
      end
    end
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
    # @mobile = true
  end
  
  helper_method :get_user_bid
  def get_user_bid
    uid = cookies[:soclshd]        
    return uid
  end    

  helper_method :get_asset
  def get_asset
    if(@mobi.present? && @mobi)
      return "img/"
    else 
      return "/assets/"
    end
  end    

  def set_ip_tracking_fields(obj, ip)
    ip = "106.51.243.30" if(Rails.env.development?)
    obj = QuesView.set_ip_tracking_fields(obj, ip)
    return obj
  end

end
