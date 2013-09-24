class PvQueriesController < ApplicationController
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
  
    #TODO: bug
    #postcode_id = Postcode.select('id').where("pcode = ?", @pv_query.postcode).first
    #annual_dni = Irradiance.select('direct').where('postcode_id = ?', postcode_id).first.direct
    #@panels = Hash.new
    #@pv_query.panels.each do |panel|
      #@panels[:annual_dni_received] = panel.annual_dni_received(annual_dni)
    #end

  end# >>>
  private
    def pv_query_params# <<<
      #enter mass assignable fields here
      params.require(:pv_query).permit(:postcode_id, panels_attributes: [:tilt, :bearing, :panel_size])
    end # >>>
end
