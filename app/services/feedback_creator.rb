class FeedbackCreator
  def initialize(current_user, params)
    @giver = current_user
    @receiver = User.find(params.fetch(:receiver_id))
    @content = params.fetch(:content)
  end

  def perform
    Feedback::FEEDBACK_TYPES.each { |name| create_feedback(name) }
  end

  private

  attr_reader :giver, :receiver, :content

  def create_feedback(name)
    if content[name].strip.present?
      Feedback.create!(giver: giver, receiver: receiver, feedback_type: name, content: content[name])
    end
  end
end
