class Users::RegistrationsController < Devise::RegistrationsController
  def create
    @user = User.new(user_params)
    @user.admin = true

    if @user.save
      flash[:success] = 'New user created'
      redirect_to root_path
    else
      render "new"
    end
  end

  def update
    @user = current_user
    @user.admin = params[:user][:admin]

    if @user.update(user_params)
      flash[:success] = 'User updated'
      redirect_to root_path
    else
      render "edit"
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end
end
