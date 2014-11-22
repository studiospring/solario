class IrradiancesController < ApplicationController
  before_filter :require_admin
  def index
    @irradiances = Irradiance.all
  end
  def new
    @irradiance = Irradiance.new
  end
  def create
    @irradiance = Irradiance.new(irradiance_params)
    if @irradiance.save
      flash[:success] = 'New irradiance created'
      redirect_to @irradiance
    else
      render "new"
    end
  end
  def show
    @irradiance = Irradiance.find(params[:id])
  end
  def edit
    @irradiance = Irradiance.find(params[:id])
  end
  def update
    @irradiance = Irradiance.find(params[:id])
    if @irradiance.update(irradiance_params)
      flash[:success] = 'Irradiance updated'
      redirect_to @irradiance
    else
      render "edit"
    end
  end
  def destroy
    @irradiance = Irradiance.find(params[:id])
    @irradiance.destroy
    redirect_to irradiances_url
  end
  private
    def irradiance_params
      #enter mass assignable fields here
      params.require(:irradiance).permit(:direct, :diffuse, :postcode_id)
    end 
end

