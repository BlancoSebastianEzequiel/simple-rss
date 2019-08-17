class App.Views.Folders extends App.View

  template: JST['application/templates/folders/folders_list']

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

  render: ->
    @$el.html(@template)
    @collection.fetch({
      data: { feed_id: @feedId }
      reset: true
    })
    this
