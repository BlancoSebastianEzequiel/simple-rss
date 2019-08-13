class App.Views.Feeds extends App.View

  template: JST['application/templates/feeds_list']

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
    @unsubscribeButton = @$el.find("#unsubscribe_#{feedItem.get("id")}")
    this.toggleEnabled(@unsubscribeButton, true)

  addAll: =>
    this.toggleNoFeedsMessage()
    @collection.forEach(this.addOne, this)

  render: ->
    @collection.fetch({ reset: true })
    this
