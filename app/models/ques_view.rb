class QuesView < ActiveRecord::Base
  attr_accessible :count, :qu_id, :uid

  def self.add_view(uid, qu_id)
    qu = QuesView.find(:first, :conditions => ["uid = ? and qu_id = ?", uid, qu_id])
    if(qu.nil?)
      qu = QuesView.new
      qu.uid = uid
      qu.qu_id = qu_id
      qu.count = 0
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
  
end
