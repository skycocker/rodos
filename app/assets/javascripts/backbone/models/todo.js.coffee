class Rodos.Models.Todo extends Backbone.Model
  paramRoot: 'todo'
  urlRoot: '/todos'

class Rodos.Collections.Todos extends Backbone.Collection
  model: Rodos.Models.Todo
  url: '/todos'
  
