Rodos.Views.Statics ||= {}

class Rodos.Views.Statics.HomeView extends Backbone.View
  template: JST["backbone/templates/statics/home"]
  
  events:
    "click .group": "pickGroup"
    "click .createTodo": "createTodo"
    "click .deleteTodo": "deleteTodo"
  
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
    groupEl = $(event.currentTarget)
    groupEl.toggleClass("active")
    
    @groupId = groupEl.data("id")
    
  createTodo: =>
    @todos.create
      title: $('.todo-title').val()
      group_id: @groupId
      
  deleteTodo: (event) =>
    todoEl = $(event.target).parent().parent()
    todoId = todoEl.data("id")
    todo = @todos.get(todoId)
    todo.destroy()
    
  render: =>
    $(@el).html(@template( todos: @todos.toJSON(), groups: @groups.toJSON() ))
    return this
    
  
