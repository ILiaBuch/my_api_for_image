class User
  include Mongoid::Document
  field :access_key
  # embeds_many :images
  has_many :images
end
