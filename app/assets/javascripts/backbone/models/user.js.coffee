class Rodos.Models.User extends Backbone.Model
  paramRoot: 'user'

  defaults:
    name: null
    email: null

class Rodos.Collections.UsersCollection extends Backbone.Collection
  model: Rodos.Models.User
  url: '/users'
