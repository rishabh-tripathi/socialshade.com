class QuesViewsController < ApplicationController
  http_basic_authenticate_with :name => USERNAME, :password => PASSWORD
  
  # GET /ques_views
  # GET /ques_views.json
  def index
    @ques_views = QuesView.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @ques_views }
    end
  end

  # GET /ques_views/1
  # GET /ques_views/1.json
  def show
    @ques_view = QuesView.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @ques_view }
    end
  end

  # GET /ques_views/new
  # GET /ques_views/new.json
  def new
    @ques_view = QuesView.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @ques_view }
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
        format.html { redirect_to @ques_view, notice: 'Ques view was successfully created.' }
        format.json { render json: @ques_view, status: :created, location: @ques_view }
      else
        format.html { render action: "new" }
        format.json { render json: @ques_view.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /ques_views/1
  # PUT /ques_views/1.json
  def update
    @ques_view = QuesView.find(params[:id])

    respond_to do |format|
      if @ques_view.update_attributes(params[:ques_view])
        format.html { redirect_to @ques_view, notice: 'Ques view was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @ques_view.errors, status: :unprocessable_entity }
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
      format.json { head :no_content }
    end
  end
end
