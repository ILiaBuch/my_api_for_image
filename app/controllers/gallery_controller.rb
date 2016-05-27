class GalleryController < ApplicationController
  REGEXP = /\Adata:([-\w]+\/[-\w\+\.]+)?;base64,(.*)/m
  respond_to :json
  def index
    @gallery = Image.all
    respond_with @gallery
  end

  def create
    @image = Image.new(gallery_params)

  			data = params[:image][:data]
        original_filename = params[:image][:filename]


        metadata = data.match(REGEXP) || []

		   	image = Base64.decode64(metadata[2])
        new_file=File.new("public/uploads/tmp/#{original_filename}", 'wb')
        new_file.write(image)


    		#@image.id = original_filename
        suffix_extension = (original_filename.match(/((.jpg)|(.png)|(.jpeg)|(.gif))\Z/)).to_s
        original_filename.slice!(suffix_extension)
        @image.image_name = original_filename
        @image.image_path = "uploads/#{@image.class.to_s.underscore}/media/#{@image.user_id}"
  			@image.media = new_file

  		if @image.save!
          File.delete(new_file)
          Image.resize_image("public/" + @image.image_path + @image.media_filename, @image.width, @image.heigh )

  				render json: { image: ActionController::Base.helpers.image_url("public/" + @image.image_path + @image.media_filename), width: @image.width, heigh: @image.heigh }
  		end
  end



  private
  def gallery_params
    params.require(:image).permit(:width, :heigh)
  end
end
