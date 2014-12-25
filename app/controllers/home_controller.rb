class HomeController < ApplicationController
  
  def index    
    @noti = Ans.get_notification(@uid)
    @qu = Qu.get_next_question(nil, @uid)
    @qu = Qu.find(:last) if(@qu.nil?)
    @qu.views += 1
    @qu.save
    QuesView.add_view(@uid, @qu.id, request.ip)
    @options = Option.find(:all, :conditions => ["qu_id = ?", @qu.id], :order => "seq")
    @ans = Ans.find(:all, :conditions => ["question_id = ?", @qu.id], :order => "created_at desc")
    @show_ans = Ans.get_show_ans(@uid, @qu, @ans)    
    @next = Qu.get_next_question(@qu, @uid)
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
      @qu.uid = @uid if(@uid.present?)
      @qu.ip = request.ip
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
      @qu.uid = @uid if(@uid.present?)
      @qu.like = 0
      @qu.views = 0
      @qu.ip = request.ip
      @qu.save      
    end
    render(:partial => "qu_save_res")
  end
    
  def answer
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
    QuesView.add_view(@uid, @qu.id, request.ip)
    @options = Option.find(:all, :conditions => ["qu_id = ?", @qu.id], :order => "seq")
    @ans = Ans.find(:all, :conditions => ["question_id = ?", @qu.id], :order => "created_at desc")    
    @show_ans = Ans.get_show_ans(@uid, @qu, @ans)
    @title = "#{@qu.text} asked on SocialShade"
    @desc = "#{@qu.text} asked on SocialShade, open space for open minded people. Ask anything to anyone without login"    
    @next = Qu.get_next_question(@qu, @uid)
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
        if(!(opts.include? ans.value.to_i))
          wrong_ans = true
        end
      end  
      if(!wrong_ans)        
        uid = @uid
        if(params[:uid].present? && (uid == params[:uid]))
          ans.ip = request.ip
          ans.uid = params[:uid]
          ans.req_details = ""
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
        sh = ""
        txt_style = "color:#ffffff"
      elsif(params[:objtype].to_i == 2)
        obj = Ans.find(params[:id])
        sh = "s"
        txt_style = ""
      end
      if(params[:type].to_i == 1)
        if(obj.like.nil?)
          obj.like = 1 
        else
          obj.like += 1
        end
        img_path = "/assets/#{sh}like.png"
        count = obj.like
      elsif(params[:type].to_i == -1)
        if(obj.unlike.nil?)
          obj.unlike = 1 
        else
          obj.unlike += 1
        end      
        img_path = "/assets/#{sh}unlike.png"
        count = obj.unlike
      end
      obj.save
      render(:partial => "like_res", :locals => {:img_path => img_path, :count => count, :txt_style => txt_style})
    else
      render(:text => "error")
    end
  end
  
  def how_to
  end
  
  def terms
  end
  
  def privacy
  end

end
