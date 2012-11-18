Rodos.Views.Statics ||= {}

class Rodos.Views.Statics.HomeView extends Backbone.View
  template: JST["backbone/templates/statics/home"]
  
  events:
    #modify todos
    "click .group": "pickGroup"
    "click .addTodoToCurrentGroup": "createTodo"
    "click .todoDestinationGroup": "createTodo"
    "click .deleteTodo": "deleteTodo"
    #modify groups
    "click .createGroup": "createGroup"
    "click .addUserToCurrentGroup": "addUser"
    "click .userDestinationGroup": "addUser"
    "click .leaveGroup": "leaveGroup"
  
  initialize: (@groups, @todos) =>
    @groups.on("reset", @render)
    @groups.on("change", @render)
    @groups.on("remove", @render)
    @groups.fetch()
    
    @todos.on("reset", @render)
    @todos.on("change", @render)
    @todos.on("remove", @render)
    @todos.fetch()
    
    $("#statics").html(@render().el)
    
  pickGroup: (event) =>
    groupEl = $(event.currentTarget)
    @groupId = groupEl.data("id")
    
    @members = new Rodos.Collections.Members()
    @members.fetch(
      data:
        group: @groupId
      async: false
    )
    
    @render(@members)
    
  createTodo: (event) =>
    clickedEl = $(event.target)
    creatorEl = clickedEl.parent()
    
    if clickedEl.hasClass("addTodoToCurrentGroup") || creatorEl.hasClass("addTodoToCurrentGroup")
      if @groupId
        destinationGroup = @groupId
      else
        $('.pickTodoTargetGroup').dropdown()
    else
      destinationGroup = creatorEl.data("id")
      
    @todos.create
      title: $('#new-todo-title').val()
      group_id: destinationGroup
    
    $("#new-todo-title").empty()
    clickedEl.tooltip("hide")
    creatorEl.tooltip("hide")
      
  deleteTodo: (event) =>
    todoEl = $(event.target).parent().parent()
    todoId = todoEl.data("id")
    todo = @todos.get(todoId)
    todo.destroy()
    
  createGroup: =>
    @groups.create
      name: $("#new-group-name").val()
    
  addUser: (event) =>
    clickedEl = $(event.target)
    creatorEl = clickedEl.parent()
    
    if clickedEl.hasClass("addUserToCurrentGroup") || creatorEl.hasClass("addUserToCurrentGroup")
      if @groupId
        destinationGroup = @groupId
      else
        $('.pickUserTargetGroup').dropdown()
    else
      destinationGroup = creatorEl.data("id")
      
    destinationGroupName = @groups.get(destinationGroup).get("name")
    userData = $("#new-user-data").val()
    
    @newuser = new Rodos.Models.Relationship()
    @newuser.set(user_data: userData)
    @newuser.set(id: destinationGroup)
    @newuser.save({}, 
      success: (model, response) ->
        klass = "alert-success"
        $("#flash").html("User "+userData+" has been added to group "+destinationGroupName+".")
        $("#flash").addClass(klass).fadeIn("fast").delay(2000).fadeOut("fast")
        setTimeout(->
          $("#flash").removeClass(klass)
        , 2300)
      error: (model, response) ->
        switch response.status
          when 409
            status = "info"
          else
            status = "error"
        klass = "alert-"+status
        $("#flash").html(response.responseText)
        $("#flash").addClass(klass).fadeIn("fast").delay(2000).fadeOut("fast")
        setTimeout(->
          $("#flash").removeClass(klass)
        , 2300)
    )
    
  leaveGroup: (event) =>
    clickedEl = $(event.target)
    leaver = clickedEl.parent().parent()
    destinationGroup = leaver.data("id")
    
    @leaving = new Rodos.Models.Relationship()
    @leaving.set(id: destinationGroup)
    @leaving.destroy()
    
    clickedEl.tooltip("hide")
    @groups.remove(destinationGroup)
    
  render: (members) =>
    if @members
      $(@el).html(@template(
        todos: @todos.toJSON()
        groups: @groups.toJSON()
        members: @members.toJSON()
      ))
    else
      $(@el).html(@template(
        todos: @todos.toJSON()
        groups: @groups.toJSON()
      ))
    
    $("[rel=tooltip]").tooltip()
    
    return this
    
