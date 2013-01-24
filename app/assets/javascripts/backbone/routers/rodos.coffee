class Rodos.Routers.RodosRouter extends Backbone.Router
  initialize: (options) ->
  
  routes: {
    ".*": "navStart"
    "_=_": "garbageCleanup"
  }
  
  navStart: =>
    if user.id != ""
      @groups = new Rodos.Collections.Groups()
      @members = new Rodos.Collections.Members()
      @todos = new Rodos.Collections.Todos()
      @participants = new Rodos.Collections.Participants()
      
      @home(@groups, @members, @todos, @participants)
    else
      @welcome()
      
  garbageCleanup: =>
    app.navigate("/", {trigger: true})
        
  welcome: =>
    @view = new Rodos.Views.Statics.WelcomeView()

  home: (groups, members, todos, participants) =>
    @view = new Rodos.Views.Statics.HomeView(groups, members, todos, participants)
