FactoryBot.define do
  factory :answer do
    body { "MyText" }
    user

    trait :invalid do
      body { nil }
    end
  end
end
