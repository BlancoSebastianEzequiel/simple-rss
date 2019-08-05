class App.Collections.Articles extends App.Collection
  model: App.Models.Article
  url: "/articles"

  initialize: ->
    this.on("remove", this.hideModel)

  hideModel: (model) ->
    model.trigger("hide")