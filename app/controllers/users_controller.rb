class UsersController < ApplicationController
   before_action :be_current_user
   respond_to :json
   def index
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
