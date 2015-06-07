class Feedback < ActiveRecord::Base
  belongs_to :giver, class_name: User, foreign_key: :giver_id
  belongs_to :receiver, class_name: User, foreign_key: :receiver_id

  scope :not_published, -> { where(published: false) }
  scope :for_display, ->(user) { where('published = true OR giver_id = ?', user.id) }

  validates :content, :giver_id, :receiver_id, :feedback_type, presence: true

  def self.publish_all
    not_published.update_all(published: true)
  end

  def self.feedbeck_types
    %w(bad good future)
  end

  def tr_class
    if feedback_type == 'good'
      'success'
    elsif feedback_type == 'bad'
      'danger'
    else
      'info'
    end
  end
end
