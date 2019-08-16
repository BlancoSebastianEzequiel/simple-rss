class App.Views.Folder extends App.View

  template: JST['application/templates/folder']

  tagName: "option",
  className: "folder_option"

  initialize: ->
    @model.on("hide", this.remove, this)

  render: ->
    name = @model.getName()
    @$el.html(@template({ name }))
    this
