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

require 'rails_helper'

RSpec.describe User, type: :model do
	before { @user = FactoryBot.build(:user) }

  subject { @user }

  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:username) }
  it { should validate_confirmation_of(:password) }
  it { should validate_uniqueness_of(:username) }

end
