require 'rails_helper'

RSpec.describe Comment, type: :model do
	before { @comment = FactoryBot.build(:comment) }

  subject { @comment }

  it { should validate_presence_of(:content) }
  it { should belong_to(:commentable) }
  it { should belong_to(:user) }
  it { should have_many(:comments).dependent(:destroy) }
end
