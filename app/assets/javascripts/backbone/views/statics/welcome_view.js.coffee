Rodos.Views.Statics ||= {}

class Rodos.Views.Statics.WelcomeView extends Backbone.View
  template: JST["backbone/templates/statics/welcome"]

  render: ->
    $(@el).html(@template())
    return this
