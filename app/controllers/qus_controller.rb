class QusController < ApplicationController
  http_basic_authenticate_with :name => USERNAME, :password => PASSWORD
  
  # GET /qus
  # GET /qus.json
  def index
    @qus = Qu.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @qus }
    end
  end

  # GET /qus/1
  # GET /qus/1.json
  def show
    @qu = Qu.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @qu }
    end
  end

  # GET /qus/new
  # GET /qus/new.json
  def new
    @qu = Qu.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @qu }
    end
  end

  # GET /qus/1/edit
  def edit
    @qu = Qu.find(params[:id])
  end

  # POST /qus
  # POST /qus.json
  def create
    @qu = Qu.new(params[:qu])

    respond_to do |format|
      if @qu.save
        format.html { redirect_to @qu, notice: 'Qu was successfully created.' }
        format.json { render json: @qu, status: :created, location: @qu }
      else
        format.html { render action: "new" }
        format.json { render json: @qu.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /qus/1
  # PUT /qus/1.json
  def update
    @qu = Qu.find(params[:id])

    respond_to do |format|
      if @qu.update_attributes(params[:qu])
        format.html { redirect_to @qu, notice: 'Qu was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @qu.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /qus/1
  # DELETE /qus/1.json
  def destroy
    @qu = Qu.find(params[:id])
    @qu.destroy

    respond_to do |format|
      format.html { redirect_to qus_url }
      format.json { head :no_content }
    end
  end
end
