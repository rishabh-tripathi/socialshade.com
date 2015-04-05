class Qu < ActiveRecord::Base
  attr_accessible :ans, :likes, :text, :qu_type, :uid, :views, :unlike, :ip, :expire, :expired, :country_code, :country_name, :region_code, :region_name, :city_name, :latitude, :longitude
  
  EXPIRE_6HR = 10
  EXPIRE_DAY = 20
  EXPIRE_WEEK = 30
  EXPIRE_MONTH = 40
  EXPIRE_NEVER = 0

  EXPIRE_TEXT = {  
    EXPIRE_6HR => "Get me answers today, ASAP",
    EXPIRE_DAY => "Get me answers in couple of days",
    EXPIRE_WEEK => "I can wait for this week",
    EXPIRE_MONTH => "It's a difficult one, I will wait for this month",
    EXPIRE_NEVER => "It's a general question, never expire",
  }

  EXPIRED_NO = 0
  EXPIRED_YES = 1  
  EXPIRED_NAMES = {
    EXPIRED_NO => "No",
    EXPIRED_YES => "Yes"
  }

  TYPE_TEXT = 0
  TYPE_SINGLE = 1
  TYPE_NAME = {
    TYPE_TEXT => "Text Based",
    TYPE_SINGLE => "Single Select"
  }

  def self.get_next_question(cur, uid) 
    exc = []
    exc << cur.id if(!cur.nil?)
    if(!uid.nil? && !uid.blank?)
      ans = Ans.find(:all, :conditions => ["uid = ?", uid])
      if(!ans.nil? && !ans.blank?)
        exc = ans.map{|a| a.question_id }
      end
    end    
    exc += QuesView.get_user_views_question(uid)
    if(!exc.nil? && !exc.blank?)
      all_avail_qus = Qu.find(:all, :conditions => ["id not in (?) and expired = ?", exc.uniq, Qu::EXPIRED_NO])
    else
      all_avail_qus = Qu.find(:all, :conditions => ["expired = ?", Qu::EXPIRED_NO], :order => "created_at desc", :limit => 10)
    end
    nxt = ([*all_avail_qus]).sample  
    return nxt
  end
  
  def self.expire_questions(exp_when)
    qus = Qu.find(:all, :conditions => ["expired = ? and expire = ?", Qu::EXPIRED_NO, exp_when])
    for q in qus
      today = Date.today
      cre = q.created_at.to_date
      diff = (today - cre).to_i
      if(q.expire == Qu::EXPIRE_6HR)
        if(diff > 0)
          q.expired = Qu::EXPIRED_YES
          q.save
        end
      elsif(q.expire == Qu::EXPIRE_DAY)
        if(diff > 2)
          q.expired = Qu::EXPIRED_YES
          q.save
        end
      elsif(q.expire == Qu::EXPIRE_WEEK)
        if(diff > 10)
          q.expired = Qu::EXPIRED_YES
          q.save
        end
      elsif(q.expire == EXPIRE_MONTH)
        if(diff > 40)
          q.expired = Qu::EXPIRED_YES
          q.save
        end
      end
    end
  end

  
end

