FactoryBot.define do
  factory :question do
    title { "MyString" }
    body { "MyString" }
    user

    trait :invalid do
      title { nil }
    end
  end
end
