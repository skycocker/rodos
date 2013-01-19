class UsersController < ApplicationController
  respond_to :json
  
  def index
    @users = User.all
  end
  
  def current
    @current_user = current_user
    
    if @current_user.provider == "facebook"
      if @token = session[:fb_access_token]
        @graph = Koala::Facebook::API.new(@token)
        @groups = @graph.get_connections('me', 'groups')
        @groups.each do |group|
          if @foundGroup = FbRelationship.find_by_fb_group(group["id"])
            Relationship.find_or_create_by_user_id_and_group_id(user_id: @current_user.id, group_id: @foundGroup.rodos_group)
          end
        end
      end
    end
    
    render json: {id: @current_user.id}
  end
end
