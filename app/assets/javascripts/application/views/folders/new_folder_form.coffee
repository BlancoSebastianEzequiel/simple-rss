class App.Views.NewFolderForm extends App.View

  template: JST['application/templates/new_folder_form']

  events:
    'click #new_folder_name_submit': 'saveFolderName'

  initialize: (options) ->
    @feedsId = options.feedsId

  render: ->
    nameError = @collection.errors.name if @collection.errors
    @$el.html(@template({ nameError }))
    @newFolderButton = @$el.find("#new_folder_name_submit")
    this.toggleEnabled(@newFolderButton, true)
    this

  setErrors: ->
    if @collection.errors
      urlError = @collection.errors.name
      @$el.find("#name_error").text(urlError)

  saveFolderName: (event) ->
    event.preventDefault()
    this.toggleEnabled(@newFolderButton, false)
    name = $("#input_name").val()
    @collection.save(name, @feedsId)
    .fail(() =>
      this.setErrors()
      this.toggleEnabled(@newFolderButton, true)
    )
    .then(() =>
      this.toggleEnabled(@newFolderButton, true)
      this.trigger("new:folder:submit")
    )

