class Rodos.Models.Member extends Backbone.Model
  paramRoot: 'member'

class Rodos.Collections.Members extends Backbone.Collection
  model: Rodos.Models.Member
  url: '/members'
