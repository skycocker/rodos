class Rodos.Models.Participant extends Backbone.Model
  urlRoot: '/participants'
  
class Rodos.Collections.Participants extends Backbone.Collection
  model: Rodos.Models.Participant
  url: '/participants'
