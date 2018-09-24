# == Schema Information
#
# Table name: users
#
#  id                     :bigint(8)        not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  username               :string           default(""), not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

FactoryBot.define do
  factory :user do
    email { FFaker::Internet.email }
    username { FFaker::Name.first_name }
    password { "12345678" }
    password_confirmation { "12345678" }

    factory :admin do
        after(:build) do |user|
            user.role = :admin
        end
    end
  end
end
