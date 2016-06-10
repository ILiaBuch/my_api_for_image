require "rails_helper"

RSpec.describe User, :type => :model do
  it { is_expected.to callback(:generate_access_key).before(:create) }
  it "has a valid factory" do
    expect(build(:user)).to be_valid
  end

   let(:user) { build(:user) }

   describe " should not  be empty " do
     it { expect(user.access_key).not_to be_empty }
   end
end
