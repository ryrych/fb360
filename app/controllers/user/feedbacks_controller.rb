class User::FeedbacksController < User::UserController
  before_action :check_if_feedback_editable, only: [:edit, :update, :destroy]
  before_action :receiver, only: [:new, :create]

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  expose(:feedback, attributes: :feedback_params)
  expose(:users) { User.active.for_display }
  expose(:feedback_types) { Feedback.feedback_types_for_select }
  expose(:q) { Feedback.for_display(current_user).ransack(params[:q]) }
  expose(:feedbacks) do
    q.sorts = 'created_at desc' if q.sorts.empty?
    q.result(distinct: true)
  end
  expose(:q_created_at_gteq) { q.created_at_gteq ? q.created_at_gteq.strftime('%d/%m/%Y') : nil }
  expose(:q_created_at_lteq) { q.created_at_lteq ? q.created_at_lteq.strftime('%d/%m/%Y') : nil }

  def create
    FeedbackCreator.new(current_user, params).perform unless current_user.id == receiver.id
    redirect_to new_user_feedback_path(receiver_id: receiver.next)
  end

  def update
    if feedback.save
      redirect_to user_feedbacks_path, notice: 'Feedback has been updated.'
    else
      render :edit
    end
  end

  def destroy
    feedback.destroy
    redirect_to user_feedbacks_path, notice: 'Feedback has been removed.'
  end

  private

  def feedback_params
    params.require(:feedback).permit(:content, :feedback_type, :receiver_id)
  end

  def check_if_feedback_editable
    if feedback.giver != current_user
      record_not_found
    elsif feedback.published?
      redirect_with_alert('You cannot edit published feedback!')
    end
  end

  def redirect_with_alert(message)
    redirect_to user_feedbacks_path, alert: message
  end

  def record_not_found
    redirect_with_alert('You cannot edit feedback created by someone else!')
  end

  def receiver
    @receiver = if params[:receiver_id]
                  User.find_by_id(params[:receiver_id]) rescue users.first
                else
                  users.first
                end
  end
end
