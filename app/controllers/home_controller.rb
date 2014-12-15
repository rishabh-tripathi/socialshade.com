class HomeController < ApplicationController

  def index    
    all_qu_count = Qu.count
    qu_id = ([*1..all_qu_count]).sample
    @qu = Qu.find(qu_id)
    @qu.views += 1
    @qu.save
    @options = Option.find(:all, :conditions => ["qu_id = ?", @qu.id], :order => "seq")
    @ans = Ans.find(:all, :conditions => ["question_id = ?", @qu.id], :order => "created_at desc")
    @show_ans = false
    @next = @qu.id
    while(@next == @qu.id)
      @next = ([*1..all_qu_count]).sample
    end
  end
  
  def ask    
  end
  
  def submit_qu
    @qu = Qu.new
    @qu.text = params[:qu]
    if(!params[:opt].nil? && !params[:opt].blank?)
      @qu.qu_type = Qu::TYPE_SINGLE
      @qu.ans = 0
      @qu.likes = 0
      @qu.views = 0
      @qu.save
      params[:opt].each do|key, value|
        opt = Option.new
        opt.qu_id = @qu.id
        opt.content = value
        opt.seq = key
        opt.save
      end
    else
      @qu.qu_type = Qu::TYPE_TEXT
      @qu.ans = 0
      @qu.likes = 0
      @qu.views = 0
      @qu.save      
    end
    render(:partial => "qu_save_res")
  end
    
  def answer
    all_qu_count = Qu.count
    @qu = Qu.find(params[:id])
    @qu.views += 1
    @qu.save
    @options = Option.find(:all, :conditions => ["qu_id = ?", @qu.id], :order => "seq")
    @ans = Ans.find(:all, :conditions => ["question_id = ?", @qu.id], :order => "created_at desc")
    @show_ans = false
    @next = @qu.id
    while(@next == @qu.id)
      @next = ([*1..all_qu_count]).sample
    end
  end

  def submit_ans
    @qu = Qu.find(params[:id])
    @options = Option.find(:all, :conditions => ["qu_id = ?", @qu.id], :order => "seq")
    wrong_ans = false
    if(!params[:ans].blank?) 
      ans = Ans.new
      ans.question_id = @qu.id
      ans.value = params[:ans]
      if(@qu.qu_type == Qu::TYPE_SINGLE)
        opts = @options.map{|a| a.id }
        if(!(opts.include? ans.value.to_i))
          wrong_ans = true
        end
      end  
      if(!wrong_ans)
        ans.ip = request.ip
        ans.req_details = ""
        ans.save
      end
    end
    if(wrong_ans)
      render(:text => "Don't Play Smart Hacker! Its an open platform. If you can't appriciate this initiative better get out") 
    else
      @ans = Ans.find(:all, :conditions => ["question_id = ?", @qu.id], :order => "created_at desc")
      @show_ans = true
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
  
end
