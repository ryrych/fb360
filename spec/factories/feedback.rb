FactoryGirl.define do
  factory :feedback do
    content 'test'
    giver { create(:user) }
    receiver { create(:user) }
    feedback_type 'good'
    published false
  end

  factory :good_feedback, parent: :feedback do
  end

  factory :bad_feedback, parent: :feedback do
    feedback_type 'bad'
  end

  factory :future_feedback, parent: :feedback do
    feedback_type 'future'
  end
end
