require 'rails_helper'

RSpec.describe List, type: :model do
	before { @list = FactoryBot.build(:list) }

  subject { @list }

  it { should validate_presence_of(:title) }
  it { should belong_to(:owner) }
  it { should have_many(:cards).dependent(:destroy) }
  it { should have_and_belong_to_many(:users) }

  describe "#assign_member" do
  	before(:all) do
			@users = FactoryBot.create_list(:user, 3)
			@list = FactoryBot.create(:list)
  	end

    it "assign members to list" do
    	@list.assign_member(@users.first.id)
    	expect(@list.users.length).to eql 1
    end

    it "returns nil if users not exist" do 
    	@list.assign_member(10)
    	expect(@list.users.length).to eql 0
    end

    it "returns nil if user is the owner" do 
    	@list.assign_member(@list.owner.id)
    	expect(@list.users.length).to eql 0
    end
  end
end
