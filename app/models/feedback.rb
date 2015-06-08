class Feedback < ActiveRecord::Base
  FEEDBACK_TYPES = %w(bad good future)
  FEEDBACK_TYPES_DICTIONARY = {'bad' => 'Improve it', 'good' => 'Keep it up', 'future' => 'Start it'}

  belongs_to :giver, class_name: User, foreign_key: :giver_id
  belongs_to :receiver, class_name: User, foreign_key: :receiver_id

  scope :not_published, -> { where(published: false) }
  scope :for_display, ->(user) { where('published = true OR giver_id = ?', user.id) }

  validates :content, :giver_id, :receiver_id, :feedback_type, presence: true

  def self.publish_all
    not_published.update_all(published: true)
  end

  def self.feedbeck_types_for_select
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
end
