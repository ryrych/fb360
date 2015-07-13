class Admin::AdminController < ApplicationController
  before_action :authenticate_user!, :check_if_admin

  private

  def check_if_admin
    redirect_to(root_path, alert: 'You have to be an admin to see this page!') unless current_user.admin?
  end
end
