class App.Collections.Folders extends App.Collection
  model: App.Models.Folder
  url: "/folders"

  initialize: ->
    this.on("remove", this.hideModel)

  hideModel: (model) ->
    model.trigger("hide")

  save: (name, feedsId) ->
    folder = new App.Models.Folder
    folder.save({ name: name, feeds_id: feedsId }, {
      success: (model, response, options) =>
        new PNotify(text: "you added to feeds to the folder!", type: 'success').get()
        this.add(folder)
      error: (model, error) =>
        @errors = JSON.parse(error.responseText).errors
    })