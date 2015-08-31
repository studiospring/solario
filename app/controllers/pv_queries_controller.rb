class PvQueriesController < ApplicationController
  # before_filter :authenticate_user!, except: [:new, :results]
  before_filter :require_admin, :except => [:new, :create]

  respond_to :html, :js

  def index
    @pv_queries = PvQuery.all
  end

  def new
    @pv_query = PvQuery.new
    @pv_query.panels.build
  end

  # Renders in new page, via create.js.coffee.
  def create
    @pv_query = PvQuery.new(pv_query_params)

    if @pv_query.save
      # Convert from array to string.
      @output_pa_array = @pv_query.output_pa_array.join(' ')
      # @column_heights = @pv_query.column_heights
      @output_pa = @pv_query.output_pa
      @query_params = @pv_query.panels
      @search_params = @pv_query.pvo_search_params
      @candidate_systems = PvOutput.search(@search_params)
      # @get_system = PvOutput.get_system(453)
      # #call search, candidate_systems...
      @similar_system = PvOutput.find_similar_system(@search_params)

      if @similar_system
        @pvo_system = PvOutput.new(@similar_system)
        # define other attributes by calling get_statistic
        @pvo_system.get_stats
        @empirical_output_pa = @pv_query.empirical_output_pa(@pvo_system.output_per_system_watt)
      end

      respond_with({:output_pa_array => @output_pa_array}, :location => new_pv_query_url)
    else
      render 'new'
    end
  end

  def show
    @pv_query = PvQuery.find(params[:id])
  end

  def edit
    @pv_query = PvQuery.find(params[:id])
    @pv_query.postcode_id = @pv_query.postcode.pcode
  end

  def update
    @pv_query = PvQuery.find(params[:id])

    if @pv_query.update(pv_query_params)
      flash[:success] = 'Pv query updated'
      redirect_to @pv_query
    else
      render "edit"
    end
  end

  def destroy
    @pv_query = PvQuery.find(params[:id])
    @pv_query.destroy
    redirect_to pv_queries_url
  end

  private

  def pv_query_params
    params.require(:pv_query).permit(:postcode_id,
                                     :panels_attributes => [:tilt, :bearing, :panel_size])
  end
end
