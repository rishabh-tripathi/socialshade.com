class QuesView < ActiveRecord::Base
  attr_accessible :count, :qu_id, :uid, :ip, :country_code, :country_name, :region_code, :region_name, :city_name, :latitude, :longitude

  def self.add_view(uid, qu_id, ip)
    qu = QuesView.find(:first, :conditions => ["uid = ? and qu_id = ?", uid, qu_id])
    if(qu.nil?)
      qu = QuesView.new
      qu.uid = uid
      qu.qu_id = qu_id
      qu.ip = ip
      qu.count = 0      
      qu = QuesView.set_ip_tracking_fields(qu, ip)
    end    
    qu.count += 1
    qu.save
  end

  def self.get_user_views_question(uid)
    ques = QuesView.find(:all, :conditions => ["uid = ?", uid])
    ques = ques.find_all{|a| a.updated_at > (DateTime.now.to_time - 30.minute).to_datetime }
    quid = []
    if(!ques.nil? && !ques.blank?)
      quid = ques.map{|a| a.qu_id }
    end
    return quid
  end

  def self.set_ip_tracking_fields(obj, ip)
    geo = Geocoder.search(ip).first
    if(geo.present?)
      obj.country_code = geo.data["country_code"] if(geo.data["country_code"].present?) 
      obj.country_name = geo.data["country_name"] if(geo.data["country_name"].present?)
      obj.region_code = geo.data["region_code"] if(geo.data["region_code"].present?)
      obj.region_name = geo.data["region_name"] if(geo.data["region_name"].present?)
      obj.city_name = geo.data["city"] if(geo.data["city"].present?)
      obj.latitude = geo.data["latitude"] if(geo.data["latitude"].present?)
      obj.longitude = geo.data["longitude"] if(geo.data["longitude"].present?)
    end
    return obj
  end

  
end
