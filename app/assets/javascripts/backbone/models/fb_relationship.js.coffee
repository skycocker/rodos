class Rodos.Models.FbRelationship extends Backbone.Model
  paramRoot: 'fb_relationship'

class Rodos.Collections.FbRelationshipsCollection extends Backbone.Collection
  model: Rodos.Models.FbRelationship
  url: '/fb_relationships'
