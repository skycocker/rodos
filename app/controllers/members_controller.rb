class MembersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :validate_group
  
  def index
    @members = Group.find(params[:group]).users
    
    respond_to do |format|
      format.json { render json: @members }
    end
  end
  
  def validate_group
    unless current_user.groups.find_by_id(params[:group])
      respond_to do |format|
        format.json { render json: "Cannot access this group.", status: :unauthorized }
      end
    end
  end
end
