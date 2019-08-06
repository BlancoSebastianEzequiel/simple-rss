class App.Collections.Feeds extends App.Collection
  model: App.Models.Feed
  url: "/feeds"

  initialize: ->
    this.on("remove", this.hideModel)

  hideModel: (model) ->
    model.trigger("hide")

  save: ->
    url = $("#input_url").val()
    feed = new App.Models.Feed { url: url }
    data = { url: url }
    feed.save("feed", data, {
      success: (model, response, options) =>
        alert("success")
        this.add(feed)
      error: (model, error) ->
        alert(JSON.stringify(JSON.parse(error.responseText).errors))
    })