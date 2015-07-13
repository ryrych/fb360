FactoryGirl.define do
  factory :user do
    sequence(:first_name) { |n| "Ultron#{n}" }
    sequence(:last_name) { |n| "Ultron#{n}" }
    sequence(:email) { |n| "#{first_name.downcase.first}.#{last_name.downcase}#{n}@selleo.com" }
    password 'secret'
    password_confirmation 'secret'
    archived false
    admin false
  end

  factory :admin, parent: :user do
    admin true
  end
end
