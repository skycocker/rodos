Rodos.Views.Statics ||= {}

class Rodos.Views.Statics.HomeView extends Backbone.View
  template: JST["backbone/templates/statics/home"]
  
  events:
    "click .group": "pickGroup"
    "click .addTodoToCurrentGroup": "createTodo"
    "click .destinationGroup": "createTodo"
    "click .deleteTodo": "deleteTodo"
    "click .createUser": "createUser"
  
  initialize: (@groups, @todos) =>
    @groups.on("reset", @render)
    @groups.on("change", @render)
    @todos.on("remove", @render)
    @groups.fetch()
    
    @todos.on("reset", @render)
    @todos.on("change", @render)
    @todos.on("remove", @render)
    @todos.fetch()
    
    $("#statics").html(@render().el)
    
  pickGroup: (event) =>
    $(".active").removeClass("active")
    groupEl = $(event.currentTarget)
    groupEl.toggleClass("active")
    
    @groupId = groupEl.data("id")
    
  createTodo: (event) =>
    clickedEl = $(event.target)
    creatorEl = $(event.target).parent()
    
    if clickedEl.hasClass("addTodoToCurrentGroup") || creatorEl.hasClass("addTodoToCurrentGroup")
      if @groupId
        destinationGroup = @groupId
        console.log(destinationGroup)
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
   
  createUser: (event) =>
    userEmail = $(".user-email").val()
    @newuser = new Rodos.Models.Relationship()
    @newuser.set(user_email: userEmail)
    @newuser.set(group_id: @destinationGroup)
    @newuser.save()
    
  render: =>
    $(@el).html(@template(
      todos: @todos.toJSON()
      groups: @groups.toJSON()
    ))
    
    $("[rel=tooltip]").tooltip()
    
    return this
    
