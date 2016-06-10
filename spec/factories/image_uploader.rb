FactoryGirl.define do
 factory :image_uploader do
   photo Rack::Test::UploadedFile.new(File.open(File.join(Rails.root, '/spec/fixtures/myfiles/myfile.png')))
 end
end
