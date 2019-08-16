class App.Views.Feeds extends App.View

  template: JST['application/templates/feeds_list']

  events:
    'click #add_to_folder': "addToFolder"

  initialize: ->
    @$el.html(@template)
    @collection.on('add', this.addOne, this)
    @collection.on('reset', this.addAll, this)
    this.listenTo(App.Events, "feed:empty:message", this.toggleNoFeedsMessage)

  toggleNoFeedsMessage: ->
    @$el.find("#no_feed_message").toggle(@collection.models.length == 0)

  addOne: (feedItem) ->
    this.toggleNoFeedsMessage()
    feedView = new App.Views.Feed(model: feedItem)
    @$el.find("#feeds_list").append(feedView.render().el)

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
    @$el.find("#add_to_folder_modal").html(addToFolder.render().el)

  render: ->
    @collection.fetch({ reset: true })
    this
