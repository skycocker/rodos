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
        @flash("info", "Pick a target group.")
        $('.pickTodoTargetGroup').trigger("click")
        return
    else
      destinationGroup = creatorEl.data("id")
      
    @todos.create
      title: $('#new-todo-title').val()
      group_id: destinationGroup
    
    @cleanup
      
  deleteTodo: (event) =>
    clickedEl = $(event.target)
    todoEl = clickedEl.parent().parent()
    todoId = todoEl.data("id")
    todo = @todos.get(todoId)
    clickedEl.tooltip("hide")
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
        @flash("info", "Pick a target group.")
        $('.pickUserTargetGroup').trigger("click")
        return
    else
      destinationGroup = creatorEl.data("id")
      
    destinationGroupName = @groups.get(destinationGroup).get("name")
    userData = $("#new-user-data").val()
    
    @newuser = new Rodos.Models.Relationship()
    @newuser.set(user_data: userData)
    @newuser.set(id: destinationGroup)
    @newuser.save({}, 
      success: (model, response) ->
        @flash("success", "User "+userData+" has been added to group "+destinationGroupName+".")
        @cleanup
      error: (model, response) ->
        switch response.status
          when 409
            status = "info"
          else
            status = "error"
        @flash(status, response.responseText)
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
    
  flash: (type, content) =>
    elem = $("#flash")
    klass = "alert-"+type
    elem.html(content).addClass(klass).fadeIn("fast").delay(2000).fadeOut("fast")
    setTimeout(->
      elem.removeClass(klass)
    , 2300)
    
  cleanup: =>
    $("#new-todo-title").empty()
    $("#new-user-data").empty()
    
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
    
