class Admin::PresentFeedbackController < Admin::AdminController
  expose(:users) { User.active.for_display }
  expose(:receiver) { receiver }
  expose(:feedbacks) { Feedback.for_presentation(receiver, 3.weeks.ago) }

  private

  def receiver
    if params[:receiver_id]
      User.find_by_id(params[:receiver_id]) rescue users.first
    else
      users.first
    end
  end
end
