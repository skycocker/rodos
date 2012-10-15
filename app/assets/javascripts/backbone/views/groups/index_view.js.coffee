Rodos.Views.Groups ||= {}

class Rodos.Views.Groups.IndexView extends Backbone.View
  template: JST["backbone/templates/groups/index"]

  initialize: () ->
    @options.groups.bind('reset', @addAll)

  addAll: () =>
    @options.groups.each(@addOne)

  addOne: (group) =>
    view = new Rodos.Views.Groups.GroupView({model : group})
    @$("tbody").append(view.render().el)

  render: =>
    $(@el).html(@template(groups: @options.groups.toJSON() ))
    @addAll()

    return this
