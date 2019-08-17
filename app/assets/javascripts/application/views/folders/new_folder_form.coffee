class App.Views.NewFolderForm extends App.View

  template: JST['application/templates/folders/new_folder_form']

  events:
    'change #input_name': 'setFolderName'

  initialize: (options) ->
    @feedsId = options.feedsId

  render: ->
    errors = @model.get("errors")
    nameError = errors.name if errors
    @$el.html(@template({ nameError }))
    this

  setFolderName: ->
    @model.set(name: $("#input_name").val())

  getFolderName: ->
    @model.get("name")
