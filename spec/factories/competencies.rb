FactoryBot.define do
  factory :competency do
    name { Faker::Educator.unique.subject }
  end
end
