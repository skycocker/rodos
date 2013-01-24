class MembersController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    if params[:group]
      unless current_user.groups.find_by_id(params[:todo][:group_id])
        respond_to do |format|
          format.json { render json: "Cannot access this group.", status: :unauthorized }
        end
      end
      @group = Group.find(params[:group])
      @members = @group.users
    else
      @groups = current_user.groups
      @members = []
      
      @groups.each do |group|
        @members << group.users
      end
      @members.flatten!
    end
    respond_to do |format|
      format.json { render json: @members }
    end
  end
end
