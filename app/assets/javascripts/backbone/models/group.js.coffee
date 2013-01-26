class Rodos.Models.Group extends Backbone.Model
  paramRoot: 'group'
  
  defaults:
    seen: true

class Rodos.Collections.Groups extends Backbone.Collection
  model: Rodos.Models.Group
  url: '/groups'
