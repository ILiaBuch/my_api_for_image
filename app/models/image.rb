class Image
  include Mongoid::Document
  include Mongoid::Timestamps
  #include Mongoid::Paranoia
  include Mongoid::Attributes::Dynamic
  include ActiveModel::Validations
  include Rails.application.routes.url_helpers
  field :width, type: Float
  field :heigh, type: Float
  field :image_name, type: String
  field :image_path, type: String
  validates_uniqueness_of :image_name
  mount_uploader :media, ImageUploader, mount_on: :media_filename


  # field :_id, type: String, default: ->{ image_name.to_s.parameterize }
  # embedded_in :user
  belongs_to :user

   def self.resize_image(self_image_with_path, width, heigh)
      image =  MiniMagick::Image.open(self_image_with_path)
      image.resize "#{width}x#{heigh}"
      image.write (self_image_with_path)
   end


end
