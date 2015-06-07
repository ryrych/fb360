class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable, :registerable
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable

  scope :for_display, -> { order(:first_name, :last_name) }
  scope :active, -> { where(archived: false) }

  validates :first_name, :last_name, presence: true

  def self.next(user)
    user_ids = active.for_display.map(&:id)
    index = user_ids.index(user.id)
    id = if index + 1 >= user_ids.count
           user_ids[0]
         else
           user_ids[index + 1]
         end
    User.find(id)
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def to_s
    full_name
  end
end
