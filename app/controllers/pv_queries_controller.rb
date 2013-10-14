class PvQueriesController < ApplicationController
  #before_filter :authenticate_user!, except: [:new, :results]
  before_filter :require_admin, except: [:new, :create, :results]

  respond_to :html, :js
  def index# <<<
    @pv_queries = PvQuery.all
  end# >>>
  def new# <<<
    @pv_query = PvQuery.new
    @pv_query.panels.build
  end# >>>
  def create# <<<
    @pv_query = PvQuery.new(pv_query_params)

    if @pv_query.save
      flash[:success] = 'Pv query created'
      redirect_to results_pv_query_path(@pv_query)
    else
      render "new"
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
  def results# <<<
    @pv_query = PvQuery.find(params[:id])
    @avg = @pv_query.avg_output_pa.join(' ') #convert from array to string
  end# >>>
  private
    def pv_query_params# <<<
      #enter mass assignable fields here
      params.require(:pv_query).permit(:postcode_id, panels_attributes: [:tilt, :bearing, :panel_size])
    end # >>>
end
