class GalleryController < ApplicationController
  respond_to :json
  REGEXP = /\Adata:([-\w]+\/[-\w\+\.]+)?;base64,(.*)/m

  def index
    @gallery = Image.all
    @gallery.each do |image|
      render json: { id: image.id, image: image_url_for_json(image.media.url), width: image.width, height: image.height  }, status: :ok
    end
  end

  def show
    @image = Image.find(params[:id])
    render json: { id: @image.id ,image: image_url_for_json(@image.media.url), width: @image.width, height: @image.height }, status: :ok
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
  			@image.media = new_file

  		if @image.save!
          File.delete(new_file)
          Image.resize_image("public/" + @image.media.url, @image.width, @image.height )
          render json: { id: @image.id ,image: image_url_for_json(@image.media.url), width: @image.width, height: @image.height  }, status: :created
  		end
  end

  def update
      @image = Image.find(params[:id])
      if @image.update_attributes(gallery_params)
        Image.resize_image("public/" + @image.media.url, @image.width, @image.height )
        render json: { id: @image.id, image: image_url_for_json(@image.media.url), width: @image.width, height: @image.height  }, status: :accepted
      end

  end




  private
  def image_url_for_json(image_path)
      ActionController::Base.helpers.image_url(image_path)
  end

  def gallery_params
    params.require(:image).permit(:width, :height)
  end

end
