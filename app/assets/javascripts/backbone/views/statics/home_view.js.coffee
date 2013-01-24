Rodos.Views.Statics ||= {}

class Rodos.Views.Statics.HomeView extends Backbone.View
  template: JST["backbone/templates/statics/home"]
  
  events:
    #modify todos
    "click .group": "pickGroup"
    "click .addTodoToCurrentGroup": "createTodo"
    "click .todoDestinationGroup": "createTodo"
    "click .deleteTodo": "deleteTodo"
    "mouseover .toggleTodoDone": "showParticipants"
    "click .toggleTodoDone": "toggleTodoDone"
    #modify groups
    "click .createGroup": "createGroup"
    "click .addUserToCurrentGroup": "addUser"
    "click .userDestinationGroup": "addUser"
    "click .leaveGroup": "leaveGroup"
    #connect rodos group to facebook group
    "click .addFacebookGroup": "addFacebookGroup"
  
  initialize: (@groups, @members, @todos, @participants) =>
    @groups.on("reset", @render)
    @groups.on("change", @render)
    @groups.on("remove", @render)
    @groups.fetch()
    
    @members.on("reset", @render)
    @members.on("change", @render)
    @members.on("remove", @render)
    @members.fetch()
    
    @todos.on("reset", @render)
    @todos.on("change", @render)
    @todos.on("remove", @render)
    @todos.fetch()
    
    @participants.on("reset", @render)
    @participants.on("change", @render)
    @participants.on("add", @render)
    @participants.on("remove", @render)
    @participants.fetch()
    
    setInterval =>
      window.user.fetch()
      @groups.fetch()
      @todos.fetch()
    , 30000
    
    $(document).on("fbApiReady", @handleFbApi)
    
    $("#statics").html(@render().el)
    
  pickGroup: (event) =>
    groupEl = $(event.currentTarget)
    @groupId = groupEl.data("id")
    
    @members.fetch({
        groupId: @groupId
      },
      success: =>
        @render(@groupId)
    )
    
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
    
    @newuser = new Rodos.Models.Relationship()
    @newuser.set(user_data: userData)
    @newuser.set(id: destinationGroup)
    @newuser.save({}, 
      success: (model, response) =>
        @flash("success", "User "+userData+" has been added to group "+destinationGroupName+".")
        @cleanup
      error: (model, response) =>
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
    
    @newgroup = new Rodos.Models.FbRelationship()
    @newgroup.set(rodos_group: @groupId)
    @newgroup.set(fb_group: @fbGroupId)
    @newgroup.save({},
      success: () =>
        @flash("success", "Group "+@button.text()+" has been successfully connected.")
      error: (response) =>
        @flash(response.status, response.responseText)
    )
    
  showParticipants: (event) =>
    @tick = $(event.target)
    @todo = @tick.closest("li")
    @todoId = @todo.data("id")
    
    prependedMarkup = "click to mark as done<br>already done by "
    markup = ""
    @doneCounter = 0
    
    @selectedParticipants = @participants.where(todo_id: @todoId)
    _.each @selectedParticipants, (participant) =>
      @participatingMembers = @members.where(id: participant.get("user_id"))
      _.each @participatingMembers, (member) =>
        ++@doneCounter
        @participantEmail = member.get("email")
        if window.user.get("id") is member.id
          prependedMarkup = "click to unmark as done<br>already done by "
          markup += "<br>you ("+@participantEmail+")"
        else
          markup += "<br>"+member.get("email")
    switch @doneCounter
      when 0
        markup = "click to mark as done<br>nobody has done this yet"
      when 1
        appendedMarkup = "person:"
        markup = prependedMarkup + @doneCounter + " " + appendedMarkup + markup
      else
        appendedMarkup = "people:"
        markup = prependedMarkup + @doneCounter + " " + appendedMarkup + markup
    @tick.tooltip({html: true, title: markup})
    @tick.tooltip("show")
    
  toggleTodoDone: (event) ->
    @tick = $(event.target)
    @todo = @tick.closest("li")
    @todoId = @todo.data("id")
    
    @selectedParticipants = @participants.where({ todo_id: @todoId, user_id: window.user.id })
    @notExists = _.isEmpty @selectedParticipants
    if @notExists
      @participants.create
        todo_id: @todoId
        user_id: window.user.id
    else
      @existing = @participants.get(@selectedParticipants[0])
      @existing.destroy()
    
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
    
  render: (groupId) =>
    if @fbApiReady is true
      $("#fb-group-name").off("keyup", @fbGroupSearch).off("focus", @fbGroupSearch)
    
    if @groupId
      selectedTodos = @todos.where({group_id: @groupId})
      todos = _.map selectedTodos, (todo) ->
        todo.toJSON()
        
      $(@el).html(@template(
        todos: todos
        groups: @groups.toJSON()
        members: @members.toJSON()
        participants: @participants.toJSON()
        groupId: @groupId
        fbApiReady: @fbApiReady
      ))
    else
      $(@el).html(@template(
        todos: @todos.toJSON()
        groups: @groups.toJSON()
        members: @members.toJSON()
        participants: @participants.toJSON()
        fbApiReady: @fbApiReady
      ))
      
    if @fbApiReady is true
      $("#fb-group-name").on("keyup", @fbGroupSearch).on("focus", @fbGroupSearch)
    
    setTimeout(->
      $(".alert").fadeOut("fast")
    , 1800)
    
    $("[rel=tooltip]").tooltip()
    return this
    
