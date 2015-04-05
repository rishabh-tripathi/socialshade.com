class HomeController < ApplicationController
  include ActionView::Helpers::DateHelper
  
  def index    
    if(@uid.present? || params[:mobi].present?)
      @noti = Ans.get_notification(@uid)
      @qu = Qu.get_next_question(nil, @uid)
      @qu = Qu.find(:last) if(@qu.nil?)
      @qu.views += 1
      @qu.save
      QuesView.add_view(@uid, @qu.id, request.ip)
      @options = Option.find(:all, :conditions => ["qu_id = ?", @qu.id], :order => "seq")
      @ans = Ans.find(:all, :conditions => ["question_id = ?", @qu.id], :order => "created_at desc")
      @show_ans = Ans.get_show_ans(@uid, @qu, @ans)    
    end
    @next = Qu.get_next_question(@qu, @uid)
    # For mobile application response
    @mobi = false
    if(params[:mobi].present?)
      @mobi = true
      render(:partial => "answer_main")
    end
  end
  
  def ask    
    @title = "Ask anything anonymously on SocialShade"
    @desc = "Ask anything anonymously, open space for open minded people. Ask anything to anyone without login"    
  end
  
  def submit_qu
    @qu = Qu.new
    @qu.text = Ans.remove_bad_words(params[:qu])
    if(!params[:opt].nil? && !params[:opt].blank?)
      @qu.qu_type = Qu::TYPE_SINGLE
      @qu.ans = 0
      @qu.like = 0
      @qu.views = 0
      @qu.uid = params[:uid]
      @qu.ip = request.ip
      @qu.expire = Qu::EXPIRE_NEVER
      @qu.expired = Qu::EXPIRED_NO
      set_ip_tracking_fields(@qu, @qu.ip.to_s)
      @qu.save
      params[:opt].each do|key, value|
        opt = Option.new
        opt.qu_id = @qu.id
        opt.content = Ans.remove_bad_words(value)
        opt.seq = key
        opt.save
      end
    else
      @qu.qu_type = Qu::TYPE_TEXT
      @qu.ans = 0
      @qu.uid = params[:uid]
      @qu.like = 0
      @qu.views = 0
      @qu.expire = Qu::EXPIRE_NEVER
      @qu.expired = Qu::EXPIRED_NO
      @qu.ip = request.ip
      set_ip_tracking_fields(@qu, @qu.ip.to_s)
      @qu.save      
    end
    render(:partial => "qu_save_res")
  end
    
  def answer 
    get_next_question   
  end 

  def get_next_qus
    get_next_question
    @mobi = true
    render(:partial => "answer_main")
  end

  def submit_ans
    @qu = Qu.find(params[:id])
    @options = Option.find(:all, :conditions => ["qu_id = ?", @qu.id], :order => "seq")
    wrong_ans = false
    if(params[:ans].present?)
      ans = Ans.new
      ans.question_id = @qu.id
      ans.value = Ans.remove_bad_words(params[:ans])
      if(@qu.qu_type == Qu::TYPE_SINGLE)
        opts = @options.map{|a| a.id }
        # if(!(opts.include? ans.value.to_i))
        #   wrong_ans = true
        # end
      end
      if(!wrong_ans)
        uid = @uid
        if(params[:uid].present?)
          ans.ip = request.ip
          ans.uid = params[:uid]
          ans.req_details = ""
          set_ip_tracking_fields(ans, ans.ip.to_s)
          ans.save
          if(@qu.ans.nil?)
            @qu.ans = 1
          else
            @qu.ans += 1
          end
          @qu.save
        else
          wrong_ans = true
        end
      end
    end
    if(wrong_ans)
      render(:text => "Don't Play Smart Hacker! Its an open platform. If you can't appriciate this initiative better get out")
    else
      if(!params[:ans].blank?)
        @ans = Ans.find(:all, :conditions => ["question_id = ?", @qu.id], :order => "created_at desc")
        @show_ans = true
      else
        @wrong_ans = true
      end
      @mobi = false
      if(params[:mobi].present?) 
        @mobi = true
      end
      render(:partial => "ans_list")
    end
  end
  
  def search
    if(!params[:query].nil? && !params[:query].blank?) 
      qus = Qu.find(:all, :conditions => ["id = ? or text like ?", params[:query], "%#{params[:query]}%"])
      if(!qus.nil?)
        if(qus.size > 1)
          qus_ids = qus.map{|a| a.id }
          qu = ([*1..qus_ids.size]).sample
          redirect_to answer_url(qus_ids[qu])
        else
          redirect_to answer_url(qus.first.id)
        end
      else
        redirect_to root_path  
      end
    else
      redirect_to root_path
    end
  end

  def show_profile    
  end
  
  def keep_profile
    @id = params[:id]
  end

  def create_like
    if(@uid.to_s == params[:uid].to_s)
      img_path = ""
      count = 1
      if(params[:objtype].to_i == 1)
        obj = Qu.find(params[:id])
        class_name = "qu-lke"
      elsif(params[:objtype].to_i == 2)
        obj = Ans.find(params[:id])
        class_name = "ans-lke"
      end
      if(params[:type].to_i == 1)
        if(obj.like.nil?)
          obj.like = 1 
        else
          obj.like += 1
        end
        count = obj.like
        thumb_type = "fa-thumbs-up"
      elsif(params[:type].to_i == -1)
        if(obj.unlike.nil?)
          obj.unlike = 1 
        else
          obj.unlike += 1
        end      
        count = obj.unlike
        thumb_type = "fa-thumbs-down"
      end
      obj.save
      render(:partial => "like_res", :locals => {:class_name => class_name, :count => count, :thumb_type => thumb_type})
    else
      render(:text => "error")
    end
  end

  def get_notification
    @uid = params[:uid] if(!@uid.present?)
    @noti = Ans.get_notification(@uid)
    render(:partial => "noti_list", :locals => {:plugin => true})
  end
  
  def how_to
  end
  
  def terms
  end
  
  def privacy
  end

  def sitemap
    @qu = Qu.find(:all, :order => "created_at desc")
  end

  def qu_rss
    @qu = Qu.find(:all, :order => "created_at desc")
    respond_to do |format|
      format.rss { render :layout => false }
    end
  end

  def trending
    @qu = Qu.find(:all, :conditions => ["ans > ? and views > ?", 0, 0], :order => ["created_at desc", "ans desc", "views desc"], :limit => 50)
    @title = "Trending Questions"
    render "question_list"
  end

  def latest
    @qu = Qu.find(:all, :conditions => ["views > ?", 0], :order => "created_at desc", :limit => 50)
    @title = "Latest Questions"
    render "question_list"
  end

  def most_liked
    @qu = Qu.find(:all, :conditions => ["views > ?", 0], :order => "created_at desc")
    @qu = @qu.sort{|a,b| b.like.to_i <=> a.like.to_i }[0..50]
    @title = "Most Liked Questions"
    render "question_list"
  end

  def most_unliked
    @qu = Qu.find(:all, :conditions => ["unlike > ?", 0], :order => ["unlike desc", "created_at desc"], :limit => 50)
    @title = "Most Unliked Questions"
    render "question_list"
  end

  def unanswered
    @qu = Qu.find(:all, :conditions => ["ans = ?", 0], :order => "views desc", :limit => 50)
    @qu = @qu.sort{|a,b| b.like.to_i <=> a.like.to_i }
    @title = "Unanswered Questions"
    render "question_list"
  end

  def activity
    qus = Qu.find(:all, :conditions => ["created_at > ?", (Date.today - 1)])
    ans = Ans.find(:all, :conditions => ["created_at > ?", (Date.today - 1)])
    @act = {}
    for q in qus
      @act[q.created_at] = ["\"<a href='#{answer_url(q.id)}'>#{q.text}</a>\" asked #{time_ago_in_words(q.created_at)} ago from #{q.country_name}", 1]
    end
    for a in ans
      q = Qu.find(a.question_id)
      @act[a.created_at] = ["\"<a href='#{answer_url(q.id)}'>#{q.text}</a>\" answered #{time_ago_in_words(a.created_at)} ago from #{a.country_name}", 2]
    end    
  end

  def contact
  end
  
  def stat
    @total_qu = Qu.count(:all)
    @total_ans = Ans.count(:all)
    @total_view = QuesView.count(:all)
    @qu_this_week = Qu.count(:conditions => ["created_at > ?", (Date.today - 7)])
    @ans_this_week = Ans.count(:conditions => ["created_at > ?", (Date.today - 7)])
    @view_this_week = QuesView.count(:conditions => ["created_at > ?", (Date.today - 7)])
    @qu_today = Qu.count(:conditions => ["created_at > ?", (Date.today - 1)])
    @ans_today = Ans.count(:conditions => ["created_at > ?", (Date.today - 1)])
    @view_today = QuesView.count(:conditions => ["created_at > ?", (Date.today - 1)])
  end

  def how_notify
    @title = "Learn how to get nofitication"
    @desc = "Ask anything anonymously, open space for open minded people. Ask anything to anyone without login"    
  end
  
  def change_expire
    @qu = Qu.find(params[:id])
    if(@qu.present?)
      @qu.expire = params[:exp].to_i
      @qu.save
    end
    render(:partial => "qu_save_res_finish")
  end

  private
  def get_next_question  
    @noti = Ans.get_notification(@uid)
    all_qu_count = Qu.count
    begin
      @qu = Qu.find(params[:id])
    rescue      
      @qu = Qu.get_next_question(nil, @uid)
      redirect_to answer_url(@qu.id)
    end
    @qu.views += 1
    @qu.save
    ip_addr = request.ip
    ip_addr = "106.51.243.30" if(Rails.env.development?)
    QuesView.add_view(@uid, @qu.id, ip_addr)
    @options = Option.find(:all, :conditions => ["qu_id = ?", @qu.id], :order => "seq")
    @ans = Ans.find(:all, :conditions => ["question_id = ?", @qu.id], :order => "created_at desc")    
    @show_ans = Ans.get_show_ans(@uid, @qu, @ans)
    @title = "#{@qu.text} asked on SocialShade"
    @desc = "#{@qu.text} asked on SocialShade, open space for open minded people. Ask anything to anyone without login"    
    @next = Qu.get_next_question(@qu, @uid)
  end

end
