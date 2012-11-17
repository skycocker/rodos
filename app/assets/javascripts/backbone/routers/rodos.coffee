class Rodos.Routers.RodosRouter extends Backbone.Router
  initialize: (options) ->
  
  routes: {
    ".*": "navStart"
    "_=_": "garbageCleanup"
  }
  
  navStart: =>
    if user.id != ""
      @groups = new Rodos.Collections.Groups()
      @todos = new Rodos.Collections.Todos()
      
      @home(@groups, @todos)
    else
      @welcome()
      
  garbageCleanup: =>
    app.navigate("/", {trigger: true})
        
  welcome: =>
    @view = new Rodos.Views.Statics.WelcomeView()

  home: (groups, todos) =>
    @view = new Rodos.Views.Statics.HomeView(groups, todos)
