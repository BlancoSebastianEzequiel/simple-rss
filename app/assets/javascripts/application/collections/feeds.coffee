class App.Collections.Feeds extends App.Collection
  model: App.Models.Feed
  url: "/feeds"

  initialize: ->
    this.on("remove", this.hideModel)

  hideModel: (model) ->
    model.trigger("hide")

  save: ->
    feed = new App.Models.Feed
    feed.save({ url: $("#input_url").val() }, {
      success: (model, response, options) =>
        alert("success")
        this.add(feed)
      error: (model, error) ->
        alert(JSON.stringify(JSON.parse(error.responseText).errors))
    })