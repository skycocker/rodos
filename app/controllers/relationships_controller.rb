class RelationshipsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :validate_group
  
  def destroy
    @relationship = Relationship.find_by_user_id_and_group_id(current_user.id, params[:id])
    
    respond_to do |format|
      if @relationship
        @relationship.destroy
        format.json { head :no_content }
      else
        format.json { head :not_found }
      end
    end
  end
  
  def update
    @newuser = User.find_by_email(params[:user_data])
    @destGroup = Group.find_by_id(params[:id])
    
    respond_to do |format|
      if @newuser && @destGroup
        @relationship = Relationship.new(user_id: @newuser.id, group_id: @destGroup.id)
        
        if @relationship.save
          format.json { head :no_content }
        else
          format.json { render json: "User #{params[:user_data]} is already a member of group #{@destGroup.name}.", status: :conflict }
        end
      else
        format.json{ render json: "User #{params[:user_data]} not found or can't access group #{@destGroup.name}.", status: :not_found }
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
