class App.Views.Feeds extends App.View

  template: JST['application/templates/feeds_list']

  events:
    'click #add_to_folder': "addToFolder"

  initialize: ->
    @collection.on('add', this.addOne, this)
    @collection.on('reset', this.addAll, this)
    this.listenTo(App.Events, "feed:empty:message", this.toggleNoFeedsMessage)

  toggleNoFeedsMessage: ->
    @$el.find("#no_feed_message").toggle(@collection.models.length == 0)

  addOne: (feedItem) ->
    this.toggleNoFeedsMessage()
    feedView = new App.Views.Feed(model: feedItem)
    this.listenTo(feedView, "feed:selected:true", this.enableAddToFolderButton)
    this.listenTo(feedView, "feed:selected:false", this.disableAddToFolderButton)
    @$el.find("#feeds_list").append(feedView.render().el)

  enableAddToFolderButton: ->
    this.toggleEnabled(@addToFolderButton, true)

  disableAddToFolderButton: ->
    notSelected = @collection.models.filter (model) -> model.isSelected()
    if notSelected.length == 0
      this.toggleEnabled(@addToFolderButton, false)

  addAll: =>
    this.toggleNoFeedsMessage()
    @collection.forEach(this.addOne, this)

  getSelectedFeeds: ->
    selectedFeeds = @collection.models.filter (model) -> model.isSelected()
    selectedFeeds.map (model) -> model.get("id")

  addToFolder: (event) ->
    event.preventDefault()
    feedsId = this.getSelectedFeeds()
    addToFolder = new App.Views.AddToFolder(collection: new App.Collections.Folders, feedsId: feedsId)
    this.listenTo(addToFolder, "add:feed:to:folder:close", this.render)
    @$el.find("#add_to_folder_modal").html(addToFolder.render().el)

  render: ->
    @$el.html(@template)
    @collection.fetch({ reset: true })
    @addToFolderButton = @$el.find("#add_to_folder")
    this.toggleEnabled(@addToFolderButton, false)
    this
