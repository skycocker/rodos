class Rodos.Models.User extends Backbone.Model
  paramRoot: 'user'
  url: '/users/current'

  defaults:
    id: ""
  
  initialize: ->
    @fetch({async: false})
