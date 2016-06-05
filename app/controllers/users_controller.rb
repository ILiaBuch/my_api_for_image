class UsersController < ApplicationController
   before_action :be_current_user, only: [:create]
   respond_to :json
   def index
     if current_user
      @user = current_user
      render json: { access_key: @user.access_key }, status: :ok
    else
      render json: { errors: [message:  "You don not have  acces_key, for get acces_key have to make POST request on /users.json" , status: 401 ] }, status: :unauthorized
    end
   end

   def create
     @user = User.new
     if @user.save
       render json: { access_key: @user.access_key }, status: :created
     end
   end
   private
    def be_current_user
        begin
          raise  if current_user
        rescue
          specify_json_error(:already_have_access, 	:forbidden)
        end
    end
end
