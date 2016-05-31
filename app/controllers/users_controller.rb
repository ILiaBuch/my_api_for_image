class UsersController < ApplicationController

   respond_to :json
   def index
      @user = User.all
      respond_with @user
   end

   def create
     @user = User.new
     if @user.save
       render json: { id: @user.id ,access_key: @user.access_key }, status: :created
     end
   end
   private
     
end
