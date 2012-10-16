class Rodos.Models.Todo extends Backbone.Model
  paramRoot: 'todo'

  defaults:
    title: null

class Rodos.Collections.TodosCollection extends Backbone.Collection
  model: Rodos.Models.Todo
  url: '/todos'
