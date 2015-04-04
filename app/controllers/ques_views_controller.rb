class QuesViewsController < ApplicationController
  http_basic_authenticate_with :name => USERNAME, :password => PASSWORD
  require 'will_paginate/array'
  
  # GET /ques_views
  # GET /ques_views.json
  def index
    if(params[:uid].present?)
      @ques_views = QuesView.find(:all, :conditions => ["uid = ?", params[:uid]], :order => "created_at desc").paginate(:page => params[:page], :per_page => 50)
    else
      @ques_views = QuesView.find(:all, :order => "created_at desc").paginate(:page => params[:page], :per_page => 50)
    end    
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /ques_views/1
  # GET /ques_views/1.json
  def show
    @ques_view = QuesView.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /ques_views/new
  # GET /ques_views/new.json
  def new
    @ques_view = QuesView.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /ques_views/1/edit
  def edit
    @ques_view = QuesView.find(params[:id])
  end

  # POST /ques_views
  # POST /ques_views.json
  def create
    @ques_view = QuesView.new(params[:ques_view])

    respond_to do |format|
      if @ques_view.save
        format.html { redirect_to @ques_view, :notice => 'Ques view was successfully created.' }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /ques_views/1
  # PUT /ques_views/1.json
  def update
    @ques_view = QuesView.find(params[:id])

    respond_to do |format|
      if @ques_view.update_attributes(params[:ques_view])
        format.html { redirect_to @ques_view, :notice => 'Ques view was successfully updated.' }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /ques_views/1
  # DELETE /ques_views/1.json
  def destroy
    @ques_view = QuesView.find(params[:id])
    @ques_view.destroy

    respond_to do |format|
      format.html { redirect_to ques_views_url }
    end
  end
end
