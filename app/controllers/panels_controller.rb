
class PanelsController < ApplicationController
  def index# <<<
    @panels = Panel.all
  end# >>>
  def show# <<<
    @panel = Panel.find(params[:id])
  end# >>>
  def new# <<<
    @panel = Panel.new
  end# >>>
  def edit# <<<
    @panel = Panel.find(params[:id])
  end# >>>
  def create# <<<
    @panel = Panel.new(params[:panel])

    if @panel.save
      flash[:success] = 'Panel was successfully created.'
      redirect_to @panel
    else
      render "new"
    end
  end# >>>
  def update# <<<
    @panel = Panel.find(params[:id])
    if @panel.update(params[:panel])
      flash[:success] = 'Panel was successfully updated.'
      redirect_to @panel
    else
      render "edit"
    end
  end# >>>
  def destroy# <<<
    @panel = Panel.find(params[:id])
    @panel.destroy
    redirect_to panels_url
  end# >>>
  private
    def panel_params# <<<
      #enter mass assignable fields here
      params.require(:panel).permit()
    end # >>>
end

