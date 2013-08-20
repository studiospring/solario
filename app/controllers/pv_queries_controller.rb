class PvQueriesController < ApplicationController
  def index# <<<
    @pv_queries = PvQuery.all
  end# >>>
  def show# <<<
    @pv_query = PvQuery.find(params[:id])
  end# >>>
  def new# <<<
    @pv_query = PvQuery.new
  end# >>>
  def edit# <<<
    @pv_query = PvQuery.find(params[:id])
  end# >>>
  def create# <<<
    @pv_query = PvQuery.new(pv_query_params)

    if @pv_query.save
      flash[:success] = 'Pv query was successfully created.'
      redirect_to results_pv_query_path(@pv_query)
    else
      render "new"
    end
  end# >>>
  def update# <<<
    @pv_query = PvQuery.find(params[:id])
    if @pv_query.update(pv_query_params)
      flash[:success] = 'Pv query was successfully updated.'
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
  end# >>>
  private
    def pv_query_params# <<<
      #enter mass assignable fields here
      params.require(:pv_query).permit(:postcode)
    end # >>>
end

