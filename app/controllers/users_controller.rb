class UsersController < ApplicationController
  respond_to :json
  
  def index
    @users = User.all
  end
  
  def current
    @current_user = current_user
    render json: {id: @current_user.id}
  end
end
