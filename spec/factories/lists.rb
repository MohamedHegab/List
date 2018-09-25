FactoryBot.define do
  factory :list do
    title { FFaker::Product.product }
    association :owner, factory: :admin
  end
end
