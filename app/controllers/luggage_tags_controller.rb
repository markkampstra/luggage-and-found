class LuggageTagsController < ApplicationController
  before_action :authenticate, except: [:public, :report_found, :qr]
  before_action :set_luggage_tag, only: [:show, :edit, :update, :destroy, :report_missing, :report_ok]
  before_action :generate_qr, only: [:public, :show, :qr]

  def public
    @luggage_tag = LuggageTag.find_by uuid: params[:id]
  end

  def report_missing
    @luggage_tag.lost! if @luggage_tag.ok_at.nil?
    redirect_to public_luggage_tag_url @luggage_tag.uuid
  end

  def report_found
    @luggage_tag = LuggageTag.find_by uuid: params[:id]
    if request.patch?
      @luggage_tag.report_found = true
      if @luggage_tag.update(luggage_tag_found_params)
        @luggage_tag.found! if @luggage_tag.ok_at.nil? && !@luggage_tag.lost_at.nil?
        redirect_to public_luggage_tag_url @luggage_tag.uuid and return
      end
    end
  end

  def qr
  end

  def report_ok
    @luggage_tag.ok!
    redirect_to public_luggage_tag_url @luggage_tag.uuid
  end


  # GET /luggage_tags
  # GET /luggage_tags.json
  def index
    @luggage_tags = current_user.luggage_tags.all
  end

  # GET /luggage_tags/1
  # GET /luggage_tags/1.json
  def show
  end

  # GET /luggage_tags/new
  def new
    @luggage_tag = current_user.luggage_tags.build
  end

  # GET /luggage_tags/1/edit
  def edit
  end

  # POST /luggage_tags
  # POST /luggage_tags.json
  def create
    @luggage_tag = current_user.luggage_tags.build(luggage_tag_params)

    respond_to do |format|
      if @luggage_tag.save
        format.html { redirect_to @luggage_tag, notice: 'Luggage tag was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /luggage_tags/1
  # PATCH/PUT /luggage_tags/1.json
  def update
    respond_to do |format|
      if @luggage_tag.update(luggage_tag_params)
        format.html { redirect_to @luggage_tag, notice: 'Luggage tag was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /luggage_tags/1
  # DELETE /luggage_tags/1.json
  def destroy
    @luggage_tag.destroy
    respond_to do |format|
      format.html { redirect_to luggage_tags_url, notice: 'Luggage tag was successfully destroyed.' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_luggage_tag
      @luggage_tag = current_user.luggage_tags.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def luggage_tag_params
      params.require(:luggage_tag).permit(:user_id, :origin, :destination, :start, :end, :lost_at, :found_at, :ok_at)
    end
    def luggage_tag_found_params
      params.require(:luggage_tag).permit(:found_by, :found_comment)
    end

    def generate_qr
      @luggage_tag = LuggageTag.find_by uuid: params[:id]
      @luggage_tag = LuggageTag.find params[:id] if @luggage_tag.nil?
      url = public_luggage_tag_url @luggage_tag.uuid

      @qrcode = RQRCode::QRCode.new(url, :size => 10, :level => :h)
    end
end
