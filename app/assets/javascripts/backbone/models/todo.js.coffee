class Rodos.Models.Todo extends Backbone.Model
  paramRoot: 'todos'

  #defaults:
    

class Rodos.Collections.Todos extends Backbone.Collection
  model: Rodos.Models.Todo
  url: '/todos'
  
