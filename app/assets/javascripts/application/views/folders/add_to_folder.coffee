class App.Views.AddToFolder extends App.View

  template: JST['application/templates/add_to_folder']

  events:
    'click #add_to_folder_submit': 'saveFolder'
    'change #user_folders_list': "getFolderName"

  initialize: (options) ->
    @folderName = "new_folder"
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

  saveFolder: (event) ->
    event.preventDefault()
    this.toggleEnabled(@addToFolderButton, false)
    alert("feeds_id: " + JSON.stringify(@feedsId))
    @collection.save(@folderName, @feedsId)
    .fail(() =>
      this.toggleEnabled(@addToFolderButton, true)
    )
    .then(() => this.render())

  render: ->
    @$el.html(@template)
    modal = @$el.find("#add_to_folder_form_modal")
    @$el.find('.modal').modal()
    modal.modal('open')
    @$el.find('.trigger-modal').modal()
    @addToFolderButton = @$el.find("#add_to_folder_submit")
    this.toggleEnabled(@addToFolderButton, true)
    @collection.fetch({ reset: true })
    this
