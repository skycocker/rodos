class Rodos.Models.Todo extends Backbone.Model
  paramRoot: 'todo'

class Rodos.Collections.Todos extends Backbone.Collection
  model: Rodos.Models.Todo
  url: '/todos'
  
