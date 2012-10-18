#= require_self
#= require_tree ./templates
#= require_tree ./models
#= require_tree ./views
#= require_tree ./routers

window.Rodos =
  Models: {}
  Collections: {}
  Routers: {}
  Views: {}
  init: ->
    window.app = new Rodos.Routers.RodosRouter()
    window.user = new Rodos.Models.User()
    Backbone.history.start({pushState: true})
    
$(document).ready ->
  Rodos.init()
