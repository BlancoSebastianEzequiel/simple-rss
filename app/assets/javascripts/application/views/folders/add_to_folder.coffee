class App.Views.AddToFolder extends App.View

  template: JST['application/templates/folders/add_to_folder']

  events:
    'click #add_to_folder_submit': 'saveFolder'
    'change #user_folders_list': "getFolderName"
    'click #new_folder': "newFolder"

  initialize: (options) ->
    @folderName = ""
    @feedsId = options.feedsId

  setErrors: ->
    errors = @model.get("errors")
    if errors
      urlError = errors.name
      @$el.find("#name_error").text(urlError)

  saveFolder: (event) ->
    event.preventDefault()
    this.toggleEnabled(@addToFolderButton, false)
    folderName = @currentFolderNameGetter.getFolderName()
    @model.save({ name: folderName, feeds_id: @feedsId }, {
      success: (model, response, options) =>
        new PNotify(text: "you added to feeds to the folder!", type: 'success').get()
        this.closeModal()
      error: (model, error) =>
        @model.errors = JSON.parse(error.responseText).errors
        this.setErrors()
        this.toggleEnabled(@addToFolderButton, true)
    })


  goToNewFolderForm: ->
    @currentFolderNameGetter = new App.Views.NewFolderForm(model: @model, feedsId: @feedsId)
    @$el.find("#user_folders_list").html(@currentFolderNameGetter.render().el)

  goToUserFoldersList: ->
    @currentFolderNameGetter = new App.Views.Folders(collection: new App.Collections.Folders)
    @$el.find("#user_folders_list").html(@currentFolderNameGetter.render().el)

  renderGoToUserFoldersListButton: ->
    folderListButton = new App.Views.GoToUserFoldersListButton
    this.listenTo(folderListButton, "user:folder:button", this.renderGoToNewFolderFormButton)
    @$el.find("#go_to_button").html(folderListButton.render().el)
    this.goToNewFolderForm()

  renderGoToNewFolderFormButton: ->
    newFolderFormButton = new App.Views.GoToNewFolderFormButton
    this.listenTo(newFolderFormButton, "new:folder:form:button", this.renderGoToUserFoldersListButton)
    @$el.find("#go_to_button").html(newFolderFormButton.render().el)
    this.goToUserFoldersList()

  closeModal: ->
    @$el.find("#add_to_folder_form_modal").modal("close")
    this.trigger("add:feed:to:folder:close")

  setModal: ->
    modal = @$el.find("#add_to_folder_form_modal")
    @$el.find('.modal').modal()
    modal.modal('open')
    @$el.find('.trigger-modal').modal()

  render: ->
    errors = @model.get("errors")
    nameError = errors.name if errors
    @$el.html(@template({ nameError }))
    this.renderGoToNewFolderFormButton()
    this.setModal()
    @addToFolderButton = @$el.find("#add_to_folder_submit")
    this.toggleEnabled(@addToFolderButton, true)
    this
