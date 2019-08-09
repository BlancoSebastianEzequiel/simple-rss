class App.Collections.Feeds extends App.Collection
  model: App.Models.Feed
  url: "/feeds"

  initialize: ->
    @buttons = {}
    @errors = undefined
    this.on("remove", this.hideModel)

  hideModel: (model) ->
    model.trigger("hide")

  save: ->
    feed = new App.Models.Feed
    feed.save({ url: $("#input_url").val() }, {
      success: (model, response, options) =>
        alert("success")
        this.add(feed)
      error: (model, error) =>
        @errors = JSON.parse(error.responseText).errors
    })

  setButton: (key, button) ->
    @buttons[key] = button
