class PanelsController < ApplicationController
  before_filter :require_admin
  def index
    @panels = Panel.all
  end

  def show
    @panel = Panel.find(params[:id])
  end

  def edit
    @panel = Panel.find(params[:id])
  end

  def update
    @panel = Panel.find(params[:id])
    if @panel.update(panel_params)
      flash[:success] = 'Panel updated'
      redirect_to @panel
    else
      render "edit"
    end
  end

  def destroy
    @panel = Panel.find(params[:id])
    @panel.destroy
    redirect_to panels_url
  end
  private
  def panel_params
    # enter mass assignable fields here
    params.require(:panel).permit(:tilt, :bearing, :panel_size)
  end
end
