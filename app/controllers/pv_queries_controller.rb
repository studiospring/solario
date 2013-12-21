class PvQueriesController < ApplicationController
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
      @output_pa_array = Array.new
      month = Array.new
      @pv_query.avg_output_pa.each_with_index do |v, i|
        if (i) % 31 == 0
          @output_pa_array << month
          month.clear
        end
        month << v
      end
      @output_pa_array = @output_pa_array.transpose
      @output_pa = @pv_query.avg_output_pa.join(' ') #convert from array to string
      #@output_pa = @pv_query.postcode.irradiance.time_zone_corrected_dni

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
