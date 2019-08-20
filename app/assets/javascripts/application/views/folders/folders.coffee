class App.Views.Folders extends App.View

  template: JST['application/templates/folders/folders_list']

  events:
    'change #folders_list': "setFolderName"

  initialize: (options) ->
    @feedId = options.feedId
    @collection = options.collection
    @collection.on('add', this.addOne, this)
    @collection.on('reset', this.addAll, this)

  addOne: (folderItem) ->
    folderView = new App.Views.Folder(model: folderItem)
    @$el.find("#folders_list").append(folderView.render().el)

  addAll: =>
    @collection.forEach(this.addOne, this)
    @$el.find("#folders_list").formSelect()

  setFolderName: (event) ->
    event.preventDefault()
    @folderName = @$el.find("#folders_list").val()

  getFolderName: ->
    @folderName

  render: ->
    @$el.html(@template)
    if @feedId
      @collection.fetch({
        data: { feed_id: @feedId }
        reset: true
      })
    else
      @collection.fetch({ reset: true })
    this
