FactoryGirl.define do
  factory :user do
  	sequence (:name) { |n| "Personality #{n}" }
  	sequence (:email) { |n| "Personality_#{n}@example.com" }
    password "foobar"
    password_confirmation "foobar"

    # Sets admin field to true
    factory :admin do
    	admin true
    end
  end
end