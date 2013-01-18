class FbRelationshipsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :validate_group
  
  def create
    @destGroup = Group.find_by_id(params[:rodos_group])
    
    respond_to do |format|
      if @destGroup
        @fbrelationship = FbRelationship.new(rodos_group: @destGroup.id, fb_group: params[:fb_group])
        
        if @fbrelationship.save
          format.json { head :no_content }
        else
          format.json { render json: "Group #{params[:fb_group_name]} has already been connected to group #{@destGroup.name}.", status: :conflict }
        end
      else
        format.json{ render json: "Can't access group #{@destGroup.name}.", status: :not_found }
      end
    end
  end
  
  def validate_group
    unless current_user.groups.find_by_id(params[:id])
      respond_to do |format|
        format.json { render json: "Cannot access this group.", status: :unauthorized }
      end
    end
  end
end
