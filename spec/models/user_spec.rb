require 'rails_helper'

RSpec.describe User, type: :model do
	before { @user = FactoryBot.build(:user) }

  subject { @user }

  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:username) }
  it { should validate_confirmation_of(:password) }
  it { should validate_uniqueness_of(:username) }

end
