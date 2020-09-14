FactoryBot.define do
  factory :slug do
    to_create { |i| i.save }
    name { "test slug" }
    url { 'https://google.com' }
    active { '1' }
  end

  trait :no_name do
    name { nil }
  end

  trait :inactive do
    active { '0' }
  end
end
