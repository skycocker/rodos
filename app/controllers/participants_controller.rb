class ParticipantsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :validate_group, only: [:destroy, :create, :update]
  
  def index
    @groups = current_user.group_ids    
    @todos = Todo.where(group_id: @groups.split(',') )
    
    @participants = []
    
    @todos.each do |todo|
      @currentParticipants = todo.participants
      @participants << @currentParticipants unless @currentParticipants.blank?
    end
    @participants.flatten!
        
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @participants }
    end
  end
  
  def destroy
    respond_to do |format|
      if @todo
        @participant = Participant.find_by_todo_id_and_user_id(@todo.id, current_user.id)
        
        if @participant.destroy
          format.json { head :no_content }
        end
      else
        format.json { head :not_found }
      end
    end
  end
  
  def create
    respond_to do |format|
      if @todo
        @participant = Participant.new(todo_id: @todo.id, user_id: current_user.id)
        
        if @participant.save
          format.json { render json: @participant, status: :created, location: @participant }
        else
          format.json { head :unprocessable_entity }
        end
      else
        format.json { head :not_found }
      end
    end
  end
  
  def validate_group
    @todoId = params[:todo_id] || Participant.find(params[:id]).todo_id
    @todo = Todo.find(@todoId)
    
    unless current_user.groups.find_by_id(@todo.group_id)
      respond_to do |format|
        format.json { render json: "Cannot access this group.", status: :unauthorized }
      end
    end
  end
end
