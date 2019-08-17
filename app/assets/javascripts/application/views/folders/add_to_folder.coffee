class App.Views.AddToFolder extends App.View

  template: JST['application/templates/folders/add_to_folder']

  events:
    'click #add_to_folder_submit': 'saveFolder'
    'change #user_folders_list': "getFolderName"
    'click #new_folder': "newFolder"

  initialize: (options) ->
    @folderName = ""
    @feedsId = options.feedsId
    @collection.on('add', this.addOne, this)
    @collection.on('reset', this.addAll, this)

  addOne: (folderItem) ->
    folderView = new App.Views.Folder(model: folderItem)
    @$el.find("#user_folders_list").append(folderView.render().el)

  addAll: =>
    @collection.forEach(this.addOne, this)
    @$el.find("#user_folders_list").formSelect()

  getFolderName: (event) ->
    event.preventDefault()
    @folderName = $("#user_folders_list").val()

  setErrors: ->
    if @collection.errors
      urlError = @collection.errors.name
      @$el.find("#name_error").text(urlError)

  saveFolder: (event) ->
    event.preventDefault()
    this.toggleEnabled(@addToFolderButton, false)
    @collection.save(@folderName, @feedsId)
    .fail(() =>
      this.setErrors()
      this.toggleEnabled(@addToFolderButton, true)
    )
    .then(() => this.closeModal())

  newFolder: ->
    newFolderForm = new App.Views.NewFolderForm(collection: @collection, feedsId: @feedsId)
    this.listenTo(newFolderForm, "new:folder:close", this.closeModal)
    @$el.find("#modal_body").html(newFolderForm.render().el)

  closeModal: ->
    @$el.find("#add_to_folder_form_modal").modal("close")
    this.trigger("add:feed:to:folder:close")

  render: ->
    nameError = @collection.errors.name if @collection.errors
    @$el.html(@template({ nameError }))
    modal = @$el.find("#add_to_folder_form_modal")
    @$el.find('.modal').modal()
    modal.modal('open')
    @$el.find('.trigger-modal').modal()
    @addToFolderButton = @$el.find("#add_to_folder_submit")
    this.toggleEnabled(@addToFolderButton, true)
    @collection.fetch({ reset: true })
    this
