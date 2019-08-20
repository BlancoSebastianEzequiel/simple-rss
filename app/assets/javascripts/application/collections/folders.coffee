class App.Collections.Folders extends App.Collection
  model: App.Models.Folder
  url: "/folders"

  initialize: ->
    this.on("remove", this.hideModel)

  hideModel: (model) ->
    model.trigger("hide")

  save: (name, feedIds) ->
    folder = new App.Models.Folder
    folder.save({ name: name, feed_ids: feedIds }, {
      success: (model, response, options) =>
        new PNotify(text: "you added to feeds to the folder!", type: 'success').get()
        this.add(folder)
      error: (model, error) =>
        @errors = JSON.parse(error.responseText).errors
    })