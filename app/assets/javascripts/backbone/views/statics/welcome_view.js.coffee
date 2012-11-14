Rodos.Views.Statics ||= {}

class Rodos.Views.Statics.WelcomeView extends Backbone.View
  template: JST["backbone/templates/statics/welcome"]
  
  initialize: =>
    $("#statics").html(@render().el)

  render: ->
    $(@el).html(@template())
    return this
