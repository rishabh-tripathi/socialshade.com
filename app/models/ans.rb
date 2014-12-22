class Ans < ActiveRecord::Base
  attr_accessible :ip, :question_id, :req_details, :value, :uid, :like, :unlike
  
  BAD_WORDS = ["4free", "4u", "acyclovir", "adderall", "adipex", "allegra", "alprazolam", "altace", "ambien", "amoxicillin", "amoxil", "amphetamine", "anal", "anime", "atfreeforum.com", "ativan", "attorney", "augmentin", "azithromycin", "baccarat", "bdsm", "benadryl", "biaxin", "bitch", "blackjack", "blowjob", "bondage", "boob", "booty", "bowflex", "bulabital", "bupropion", "butalbital", "carisoprodol", "cartier", "celebrex", "celexa", "cialis", "cipro", "citalopram", "claritin", "clonazepam", "cock", "codeine", "codine", "crestor", "crotch", "cum", "cunt", "cyclen", "cyclobenzaprine", "cymbalta", "diazepam", "dick", "didrex", "diovan", "directbookmarks.info", "doxycycline", "drugstores", "edvttj", "effexor", "elavil", "ephedra", "ephedrine", "erotica", "escort", "famvir", "fioricet", "freewebs", "fuck", "gambling", "gay", "glucophage", "helsinki", "hentai", "hoodia", "horny", "hydrochlorothiazide", "hydrocodone", "incest", "indianapolis", "lamictal", "lasix", "levaquin", "levitra", "lexapro", "lexus", "lipitor", "lopressor", "lorazepam", "masterbating", "meridia", "mevacor", "minolche", "myfreedir.info", "mysex", "nexium", "nicotine", "norvasc", "nude", "orgasm", "orgy", "oxycodone", "oxycontin", "p0tassium", "panties", "panty", "paxil", "penis", "percocet", "phentermine", "plavix", "porn", "pravachol", "prednisone", "prevacid", "prilosec", "propecia", "protonix", "prozac", "pussy", "refinance", "ritalin", "seroquel", "sex", "silveno", "swinger", "tadalafil", "tadalis", "tawnee", "testosterone", "tetracycline", "tit", "tramadol", "trazodone", "twinks", "ultracet", "ultram", "valerian", "valium", "viagra", "vicodin", "vioxx", "wellbutrin", "xanax", "xenical", "xxx", "zanaflex", "zenegra", "zithromax", "zocor", "zoloft", "zolus", "zovirax", "zyprexa", "byob", "poze", "naked", "coolhu", "booker",  "freenet", "-online", "cumshot", "ownsthis", "bllogspot", "baccarrat", "thorcarlson", "jrcreations", "macinstruct", "slot-machine", "ottawavalleyag", "discreetordering", "aceteminophen", "cephalaxin", "vicoprofen", "oxycontin", "oxycodone", "tramadol", "lunestra", "fioricet", "lexapro", "valtrex", "titties", "vicodin", "valium", "hqtube", "clomid", "porno", "xanax", "pills", "tits", "ass", "gdf", "gds"] 

  def self.remove_bad_words(value)
    begin
      ans_a = value.split(/\W+/)
      words_to_replace = []
      ans_a.each do|a| 
        if(Ans::BAD_WORDS.include? a.downcase)
          words_to_replace << a.downcase
        end
      end
      if(!words_to_replace.blank?)
        words_to_replace.each do|w|
          word = w.to_s
          c = w.length
          r = ""
          r[0] = word[0]
          for x in 1..(c-1)
            r[x] = "*"
          end
          value = value.gsub(w, r)
        end
      end
    rescue Exception => ex
      logger.info(ex.to_s)
    end
    return value
  end
  
  def self.get_notification(uid)
    noti = []
    last_visit_obj = QuesView.find(:first, :conditions => ["uid = ?", uid], :order => "updated_at desc")
    if(!last_visit_obj.nil? && false)
      last_visit_date = last_visit_obj.updated_at
    end    
    question_by_this_user = Qu.find(:all, :conditions => ["uid = ?", uid])
    if(!question_by_this_user.nil? && !question_by_this_user.blank?)      
      for q in question_by_this_user
        if(!last_visit_date.nil?)
          ans = Ans.find(:all, :conditions => ["uid != ? and question_id = ? and created_at > ?", uid, q.id, last_visit_date]) 
        else
          ans = Ans.find(:all, :conditions => ["uid != ? and question_id = ?", uid, q.id]) 
        end
        if(!ans.nil? && !ans.blank?)
          ans = ans.sort{|a,b| b.updated_at <=> a.updated_at }
          noti << [q.id, "Your question '#{q.text}' got #{ans.size} new answer, click to view", ans.first.updated_at]
        end
      end
    end
    answer_by_this_user = Ans.find(:all, :conditions => ["uid = ?", uid])
    if(answer_by_this_user.present?)
      qids = answer_by_this_user.map{|a| a.question_id }
      if(qids.present?)
        qids = qids.uniq
        for q in qids
          if(!last_visit_date.nil?)
            ans = Ans.find(:all, :conditions => ["uid != ? and question_id = ? and created_at > ?", uid, q, last_visit_date]) 
          else
            ans = Ans.find(:all, :conditions => ["uid != ? and question_id = ?", uid, q]) 
          end
          if(!ans.nil? && !ans.blank?)
            ans = ans.sort{|a,b| b.updated_at <=> a.updated_at }
            qu = Qu.find(q)
            noti << [q, "'#{qu.text}' got #{ans.size} more answers, click to view", ans.first.updated_at]
          end
        end
      end      
    end
    if(!noti.blank?)
      noti = noti.sort{|a,b| b[3] <=> a[3] }
    else
      # noti << [nil, "Ask your question to anyone anonymously", nil]
    end
    return noti
  end

  def self.get_show_ans(uid, qu, ans)
    show_ans = false
    if(uid.present?)
      show_ans = true if(qu.uid.to_s == uid.to_s) 
      if(!show_ans && ans.present?)
        a = ans.find{|a| (a.uid == uid) }
        show_ans = true if(a.present?) 
      end
    end
    return show_ans
  end
end
