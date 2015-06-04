FactoryGirl.define do
  factory :user do
    username 'username'
    email 'email@email.com'
    password 'password'
    password_confirmation 'password'
  end

  factory :authentication do
    provider 'instagram'
    uid '1'
    user
  end
end
