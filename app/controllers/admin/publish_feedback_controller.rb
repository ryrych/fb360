class Admin::PublishFeedbackController < Admin::AdminController
  expose(:not_published_feedback_count) { Feedback.not_published.count }

  def update
    Feedback.publish_all
    flash[:notice] = 'You have published all feedbacks!'
    redirect_to admin_publish_feedback_path
  end
end
