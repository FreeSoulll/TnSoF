FactoryBot.define do
  factory :award do
    title { 'Award title' }
    question
    user { nil }
    image { Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/files/image.jpg") }
  end
end
