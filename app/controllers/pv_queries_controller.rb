class PvQueriesController < ApplicationController
  require 'net/http' #for api call to pvoutput.org
  #before_filter :authenticate_user!, except: [:new, :results]
  before_filter :require_admin, except: [:new, :create]

  respond_to :html, :js
  def index# <<<
    @pv_queries = PvQuery.all
  end# >>>
  def new# <<<
    @pv_query = PvQuery.new
    @pv_query.panels.build
  end# >>>
  #renders in new page, via create.js.coffee
  def create# <<<
    @pv_query = PvQuery.new(pv_query_params)

    if @pv_query.save
      @output_pa = @pv_query.avg_output_pa.join(' ') #convert from array to string
      #@column_heights = @pv_query.column_heights
      @total_output_pa = @pv_query.total_output_pa
      @query_params = @pv_query.panels

      uri = URI('http://pvoutput.org/service/r2/search.jsp')
      req = Net::HTTP::Post.new(uri)
      req['X-Pvoutput-Apikey'] = 'a0ac0021b1351c9658e4ff80c2bc5944405af134'
      req['X-Pvoutput-SystemId'] = '26011'
      params = { 'q'        => '2031',
                 'country'  => 'Australia' }
      req.set_form_data(params)

      @search_results = Net::HTTP.start(uri.hostname, uri.port) do |http|
        http.request(req)
      end

      #Net::HTTP.start(uri.host, uri.port) do |http|
        #request = Net::HTTP::Get.new uri

        #response = http.request request # Net::HTTPResponse object
      #end
      #@search_results = Net::HTTP.post_form(URI.parse('http://pvoutput.org/service/r2/search.jsp'), params)
      #puts x.body

      respond_with({output_pa: @output_pa}, location: new_pv_query_url)
    else
      render 'new'
    end
  end# >>>
  def show# <<<
    @pv_query = PvQuery.find(params[:id])
  end# >>>
  def edit# <<<
    @pv_query = PvQuery.find(params[:id])
    @pv_query.postcode_id = @pv_query.postcode.pcode
  end# >>>
  def update# <<<
    @pv_query = PvQuery.find(params[:id])
    if @pv_query.update(pv_query_params)
      flash[:success] = 'Pv query updated'
      redirect_to @pv_query
    else
      render "edit"
    end
  end# >>>
  def destroy# <<<
    @pv_query = PvQuery.find(params[:id])
    @pv_query.destroy
    redirect_to pv_queries_url
  end# >>>
  private
    def pv_query_params# <<<
      #enter mass assignable fields here
      params.require(:pv_query).permit(:postcode_id, panels_attributes: [:tilt, :bearing, :panel_size])
    end # >>>
end
