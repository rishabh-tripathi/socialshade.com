class Qu < ActiveRecord::Base
  attr_accessible :ans, :likes, :text, :qu_type, :uid, :views, :unlike, :ip, :expire
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
      all_avail_qus = Qu.find(:all, :conditions => ["id not in (?)", exc.uniq])
    else
      all_avail_qus = Qu.find(:all, :order => "created_at desc", :limit => 10)
    end
    nxt = ([*all_avail_qus]).sample  
    return nxt
  end

end

