require 'spec_helper'


RSpec.describe Image, :type => :model do

  it "has a valid factory" do
    expect(build(:image)).to be_valid
  end

   let(:image) { build(:image) }

  describe "should be valid" do
     it { is_expected.to validate_presence_of(:width) }
     it { is_expected.to validate_presence_of(:height) }
     it { is_expected.to validate_uniqueness_of(:image_name) }
  end

  describe "should be associated with user" do
     it { is_expected.to belong_to(:user)}
  end
end
