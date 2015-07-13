class Feedback < ActiveRecord::Base
  FEEDBACK_TYPES = %w(bad good future)
  FEEDBACK_TYPES_DICTIONARY = {'bad' => 'Improve it', 'good' => 'Keep it up', 'future' => 'Start it'}

  belongs_to :giver, class_name: User, foreign_key: :giver_id
  belongs_to :receiver, class_name: User, foreign_key: :receiver_id

  scope :not_published, -> { where(published: false) }
  scope :for_display, ->(giver) { where('published = true OR giver_id = ?', giver.id) }
  scope :for_presentation, ->(receiver, date) do
    where('published = true AND receiver_id = ? AND published_at > ?', receiver.id, date).order('feedback_type, receiver_id')
  end

  validates :content, :giver_id, :receiver_id, :feedback_type, presence: true
  validate :feedback_to_myself

  def self.publish_all
    not_published.update_all(published: true, published_at: Date.today)
  end

  def self.feedback_types_for_select
    FEEDBACK_TYPES.map { |type| [FEEDBACK_TYPES_DICTIONARY[type], type] }
  end

  def tr_class
    if feedback_type == 'good'
      'success'
    elsif feedback_type == 'bad'
      'orange'
    else
      'info'
    end
  end

  private

  def feedback_to_myself
    errors.add(:receiver_id, 'You cannot add feedback to yourself!') if giver_id == receiver_id
  end
end
