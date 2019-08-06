class App.Collections.Feeds extends App.Collection
  model: App.Models.Feed
  url: "/feeds"

  initialize: ->
    this.on("remove", this.hideModel)

  hideModel: (model) ->
    model.trigger("hide")

  save: ->
    feed = new App.Models.Feed { url: $("#input_url").val() }
    feed.save({
      success: (model, response, options) =>
        alert("success")
        this.add(feed)
      error: (model, error) =>
        alert(JSON.stringify(JSON.parse(error.responseText).errors))
    })