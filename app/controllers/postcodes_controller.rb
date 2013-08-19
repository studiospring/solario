class PostcodesController < ApplicationController
  def index# <<<
    @postcodes = Postcode.all.limit(10)
  end# >>>
  def show# <<<
    @postcode = Postcode.find(params[:id])
  end# >>>
  def new# <<<
    @postcode = Postcode.new
  end# >>>
  def edit# <<<
    @postcode = Postcode.find(params[:id])
  end# >>>
  def create# <<<
    @postcode = Postcode.new(params[:postcode])

    if @postcode.save
      flash[:success] = 'Postcode was successfully created.'
      redirect_to @postcode
    else
      render "new"
    end
  end# >>>
  def update# <<<
    @postcode = Postcode.find(params[:id])
    if @postcode.update(params[:postcode])
      flash[:success] = 'Postcode was successfully updated.'
      redirect_to @postcode
    else
      render "edit"
    end
  end# >>>
  def destroy# <<<
    @postcode = Postcode.find(params[:id])
    @postcode.destroy
    redirect_to postcodes_url
  end# >>>
  private
    def postcode_params# <<<
      #enter mass assignable fields here
      params.require(:postcode).permit(:id, :pcode, :suburb, :state, :latitude, :longitude)
    end # >>>
end

