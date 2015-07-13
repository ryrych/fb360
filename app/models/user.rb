class User < ActiveRecord::Base
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable

  scope :for_display, -> { order(:first_name, :last_name) }
  scope :active, -> { where(archived: false) }

  validates :first_name, :last_name, presence: true

  def next
    find_another do |user_ids, index|
      (index + 1 >= user_ids.count) ? user_ids[0] : user_ids[index + 1]
    end
  end

  def previous
    find_another do |user_ids, index|
      (index - 1 < 0) ? user_ids[user_ids.count - 1] : user_ids[index - 1]
    end
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  alias_method :to_s, :full_name

  private

  def find_another(&block)
    user_ids = User.active.for_display.map(&:id)
    index = user_ids.index(id)
    id = yield(user_ids, index)
    User.find(id)
  end
end
