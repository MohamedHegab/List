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

  it { should respond_to(:auth_token) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:username) }
  it { should validate_confirmation_of(:password) }
  it { should validate_uniqueness_of(:username) }
  it { should validate_uniqueness_of(:auth_token)}
  it { should have_many(:owns_lists).dependent(:destroy) }
  it { should have_many(:owns_cards).dependent(:destroy) }
  it { should have_and_belong_to_many(:lists) }

	describe "#generate_authentication_token!" do
    it "generates a unique token" do
      allow(Devise).to receive(:friendly_token).and_return("auniquetoken123")
      @user.generate_authentication_token!
      expect(@user.auth_token).to eql "auniquetoken123"
    end

    it "generates another token when one already has been taken" do
      existing_user = FactoryBot.create(:admin, auth_token: "auniquetoken123")
      @user.generate_authentication_token!
      expect(@user.auth_token).not_to eql existing_user.auth_token
    end
  end
end
