require 'spec_helper'
require 'carrierwave/test/matchers'

describe ImageUploader do
  include CarrierWave::Test::Matchers

  let(:image) { create :image }
  let(:uploader) { ImageUploader.new(image, :media) }

  before do
    ImageUploader.enable_processing = true
    File.open('spec/fixtures/myfiles/myfile.png') { |f| uploader.store!(f) }
  end

  after do
    ImageUploader.enable_processing = false
    uploader.remove!
  end

  it "has the correct format" do
    expect(uploader).to be_format('png')
  end

end
