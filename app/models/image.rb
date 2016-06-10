class Image
  include Mongoid::Document
  include Mongoid::Timestamps
  #include Mongoid::Paranoia
  include Mongoid::Attributes::Dynamic
  include ActiveModel::Validations
  include Rails.application.routes.url_helpers
  field :width, type: Float
  field :height, type: Float
  field :image_name, type: String
  validates_presence_of :width
  validates_presence_of :height 
  validates_uniqueness_of :image_name, presence: true
  mount_uploader :media, ImageUploader, mount_on: :media_filename

  belongs_to :user

   def self.resize_image(self_image_with_path, width, heigh)
      image =  MiniMagick::Image.open(self_image_with_path)
      image.resize "#{width}x#{heigh}"
      image.write (self_image_with_path)
   end
end
