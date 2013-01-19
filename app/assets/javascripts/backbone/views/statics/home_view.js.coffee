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
    #connect rodos group to facebook group
    "click .addFacebookGroup": "addFacebookGroup"
  
  initialize: (@groups, @todos) =>
    @groups.on("reset", @render)
    @groups.on("change", @render)
    @groups.on("remove", @render)
    @groups.fetch()
    
    @todos.on("reset", @render)
    @todos.on("change", @render)
    @todos.on("remove", @render)
    @todos.fetch()
    
    $(document).on("fbApiReady", @handleFbApi)
    
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
    
    @render(@members, @groupId)
    
  createTodo: (event) =>
    clickedEl = $(event.target)
    creatorEl = clickedEl.parent()
    
    if clickedEl.hasClass("addTodoToCurrentGroup") || creatorEl.hasClass("addTodoToCurrentGroup")
      if @groupId
        destinationGroup = @groupId
      else
        @flash("info", "Pick a target group.")
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
        return
    else
      destinationGroup = creatorEl.data("id")
      
    destinationGroupName = @groups.get(destinationGroup).get("name")
    userData = $("#new-user-data").val()
    that = this
    
    @newuser = new Rodos.Models.Relationship()
    @newuser.set(user_data: userData)
    @newuser.set(id: destinationGroup)
    @newuser.save({}, 
      success: (model, response) ->
        that.flash("success", "User "+userData+" has been added to group "+destinationGroupName+".")
        @cleanup
      error: (model, response) ->
        switch response.status
          when 409
            status = "info"
          else
            status = "error"
        that.flash(status, response.responseText)
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
    
  handleFbApi: =>
    @fbApiReady = true
    @render()
    $("#fb-group-name").on("keyup", @fbGroupSearch).on("focus", @fbGroupSearch)
    
  fbGroupSearch: (event) =>
    inputField = $(event.target)
    input = inputField.val()
    @fbGroups = $(window.fbUserGroups)
    @selectedGroups = new Array()
    
    $("#fbGroupList").empty()
    @fbGroups.each ->
      markup = "<li><a data-group-id='"+@id+"' class='addFacebookGroup dropdown-submenu'>"+@name+"</a></li>"
      $("#fbGroupList").append(markup) unless @name.toLowerCase().indexOf(input) is -1
      
  addFacebookGroup: (event) =>
    @button = $(event.target)
    @fbGroupId = @button.data("group-id")
    that = this
    
    @newgroup = new Rodos.Models.FbRelationship()
    @newgroup.set(rodos_group: @groupId)
    @newgroup.set(fb_group: @fbGroupId)
    @newgroup.save({},
      success: () ->
        that.flash("success", "Group "+that.button.text()+" has been successfully connected.")
      error: (response) ->
        that.flash(response.status, response.responseText)
    )
      
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
    
  render: (members, groupId) =>
    if @fbApiReady is true
      $("#fb-group-name").off("keyup", @fbGroupSearch).off("focus", @fbGroupSearch)
    
    if @members && @groupId
      selectedTodos = @todos.where({group_id: @groupId})
      todos = _.map selectedTodos, (todo) ->
        todo.toJSON()
        
      $(@el).html(@template(
        todos: todos
        groups: @groups.toJSON()
        members: @members.toJSON()
        groupId: @groupId
        fbApiReady: @fbApiReady
      ))
    else
      $(@el).html(@template(
        todos: @todos.toJSON()
        groups: @groups.toJSON()
        fbApiReady: @fbApiReady
      ))
      
    if @fbApiReady is true
      $("#fb-group-name").on("keyup", @fbGroupSearch).on("focus", @fbGroupSearch)
    
    setTimeout(->
      $(".alert").fadeOut("fast")
    , 1800)
    
    $("[rel=tooltip]").tooltip()
    return this
    
