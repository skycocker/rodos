class Rodos.Routers.RodosRouter extends Backbone.Router
  initialize: (options) ->
  
  routes: {
    ".*": "navStart"
    "welcome": "welcome"
    "home": "home"
  }
  
  navStart: =>
    if user.id != ""
      @home()
    else
      @welcome()
        
  welcome: ->
    @setView(Rodos.Views.Statics.WelcomeView)

  home: ->
    @setView(Rodos.Views.Statics.HomeView)
    
  setView: (view) =>
    @view = new view()
    $("#statics").html(@view.render().el)
