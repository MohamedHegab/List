require 'rails_helper'

RSpec.describe Card, type: :model do
	before { @card = FactoryBot.build(:card) }

  subject { @card }

  it { should validate_presence_of(:title) }
  it { should belong_to(:owner) }
  it { should belong_to(:list) }
  it { should have_many(:comments).dependent(:destroy) }
end
