class Rodos.Models.Group extends Backbone.Model
  paramRoot: 'group'

  defaults:
    name: null

class Rodos.Collections.GroupsCollection extends Backbone.Collection
  model: Rodos.Models.Group
  url: '/groups'
