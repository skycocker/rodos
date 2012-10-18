Rodos.Views.Statics ||= {}

class Rodos.Views.Statics.HomeView extends Backbone.View
  template: JST["backbone/templates/statics/home"]
  
  initialize: ->
    @todos = new Rodos.Collections.Todos()
    @todos.on("reset", @render, this);
    @todos.fetch()
  
  render: () ->
    $(@el).html(@template(todos: @todos.toJSON()))
    return this
  
