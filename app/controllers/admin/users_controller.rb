class Admin::UsersController < Admin::AdminController
  expose(:user, attributes: :user_params)
  expose(:users) { User.order(:first_name, :last_name) }

  def create
    if user.save
      redirect_to admin_users_path(notice: 'User has been created.')
    else
      render :new
    end
  end

  def update
    if user.save
      redirect_to admin_users_path(notice: 'User has been updated.')
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :first_name, :last_name, :archived, :admin)
  end
end
