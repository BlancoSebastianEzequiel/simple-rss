class App.Collections.Feeds extends App.Collection
  model: App.Models.Feeds
  url: "/feeds"

  initialize: ->
    this.on("remove", this.hideModel)

  hideModel: (model) ->
    model.trigger("hide")