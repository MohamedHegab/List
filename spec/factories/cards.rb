FactoryBot.define do
  factory :card do
    title { FFaker::Product.product }
    description { FFaker::Lorem.paragraph }
    association :owner, factory: :admin
    list
  end
end
