class AnsController < ApplicationController
  http_basic_authenticate_with :name => USERNAME, :password => PASSWORD
  require 'will_paginate/array'

  # GET /ans
  # GET /ans.json
  def index
    if(params[:uid].present?)
      @ans = Ans.find(:all, :conditions => ["uid = ?", params[:uid]], :order => "created_at desc").paginate(:page => params[:page], :per_page => 50)
    else
      @ans = Ans.find(:all, :order => "created_at desc").paginate(:page => params[:page], :per_page => 50)
    end    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @ans }
    end
  end

  # GET /ans/1
  # GET /ans/1.json
  def show
    @an = Ans.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @an }
    end
  end

  # GET /ans/new
  # GET /ans/new.json
  def new
    @an = Ans.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @an }
    end
  end

  # GET /ans/1/edit
  def edit
    @an = Ans.find(params[:id])
  end

  # POST /ans
  # POST /ans.json
  def create
    @an = Ans.new(params[:an])

    respond_to do |format|
      if @an.save
        format.html { redirect_to @an, :notice => 'Ans was successfully created.' }
        format.json { render :json => @an, :status => :created, :location => @an }
      else
        format.html { render :action => "new" }
        format.json { render :json => @an.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /ans/1
  # PUT /ans/1.json
  def update
    @an = Ans.find(params[:id])

    respond_to do |format|
      if @an.update_attributes(params[:an])
        format.html { redirect_to @an, :notice => 'Ans was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @an.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /ans/1
  # DELETE /ans/1.json
  def destroy
    @an = Ans.find(params[:id])
    @an.destroy

    respond_to do |format|
      format.html { redirect_to ans_url }
      format.json { head :no_content }
    end
  end
end
