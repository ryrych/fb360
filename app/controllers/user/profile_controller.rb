class User::ProfileController < User::UserController
  expose(:user) { current_user }

  def update
    if user.update_attributes(user_params)
      redirect_to edit_user_profile_path, notice: 'Profile has been updated.'
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
