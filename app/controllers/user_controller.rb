class UserController < ApplicationController

   respond_to :json
   def index
      @user = User.last
      respond_with @user
   end
end
