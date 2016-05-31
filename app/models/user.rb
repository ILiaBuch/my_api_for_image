class User
  include Mongoid::Document
  field :access_key
  # embeds_many :images
  has_many :images
  before_create :generate_access_key

  private
  def generate_access_key
     temp_arr = SecureRandom.hex(rand(1..9)).split('').map {|i| i.to_i unless i =~ /[a-zA-Z]/}.compact
     if temp_arr.length == 6
       temp_arr
     elsif temp_arr.length < 6
       while temp_arr.length != 6
         temp_arr << rand(9)
       end
     elsif temp_arr.length > 6
       while temp_arr.length != 6
         temp_arr.delete_at(rand(0..temp_arr.length))
       end
     end
     self.access_key = (0...2).map{65.+(rand(25)).chr}.join << temp_arr.join
  end
end
