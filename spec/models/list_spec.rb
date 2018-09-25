require 'rails_helper'

RSpec.describe List, type: :model do
	before { @list = FactoryBot.build(:list) }

  subject { @list }

  it { should validate_presence_of(:title) }
  it { should belong_to(:owner) }
end
