class App.Collections.Articles extends App.Collection
  model: App.Models.Articles
  url: "/articles"

  initialize: ->
    this.on("remove", this.hideModel)

  hideModel: (model) ->
    model.trigger("hide")