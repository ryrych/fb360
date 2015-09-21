class User < ActiveRecord::Base
  devise :omniauthable, :omniauth_providers => [:google_oauth2]

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

  def self.from_omniauth(auth_data)
    User.find_or_create_by email: auth_data[:info][:email],
      uid:        auth_data[:uid],
      first_name: auth_data[:info][:first_name],
      last_name:  auth_data[:info][:last_name]
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
