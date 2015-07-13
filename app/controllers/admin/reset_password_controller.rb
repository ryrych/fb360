class Admin::ResetPasswordController < Admin::AdminController
  def update
    user = User.find(params[:user_id])
    user.update_attribute(:password, 'secret')
    redirect_to edit_admin_user_path(user), notice: 'User password has been changed to "secret".'
  end
end
