Rodos.Views.Statics ||= {}

class Rodos.Views.Statics.HomeView extends Backbone.View
  template: JST["backbone/templates/statics/home"]
  
  initialize: =>
    @groups = new Rodos.Collections.Groups()
    @groups.on("reset", @render, this)
    @groups.fetch()
    
    @todos = new Rodos.Collections.Todos()
    @todos.on("reset", @render, this)
    @todos.fetch()
      
  render: () =>
    $(@el).html(@template( todos: @todos.toJSON(), groups: @groups.toJSON() ))
    return this
    
  
