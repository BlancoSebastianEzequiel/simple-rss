class App.Views.Feeds extends App.View

  template: JST['application/templates/feeds_list']

  events:
    'click .unsubscribe': 'unsubscribeFeed'
    'click .get_articles': 'getArticles'

  initialize: ->
    @$el.html(@template)
    @collection.on('add', this.addOne, this)
    @collection.on('change', this.addAll, this)

  addOne: (feedItem) ->
    feedView = new App.Views.Feed(model: feedItem)
    @$el.find("#feeds_list").append(feedView.render().el)
    @unsubscribeButton = @$el.find("#unsubscribe_#{feedItem.get("id")}")
    this.toggleEnabled(@unsubscribeButton, true)

  addAll: ->
    @collection.forEach(this.addOne, this)

  unsubscribeFeed: (event) ->
    event.preventDefault()
    this.toggleEnabled(@unsubscribeButton, false)
    this.toggleEnabled(@collection.buttons.subscribeButton, false)
    if window.confirm("Do you really unsubscribe?")
      feed = @collection.get($(event.target).data('id'))
      feed.destroy({
        success: (model, response, options) =>
          alert("Deleted")
          this.toggleEnabled(@unsubscribeButton, true)
          this.toggleEnabled(@collection.buttons.subscribeButton, true)
        error: (error) ->
          alert(JSON.stringify(JSON.parse(error.responseText).errors))
      })
    else
      this.toggleEnabled(@unsubscribeButton, true)
      this.toggleEnabled(@collection.buttons.subscribeButton, true)

  getArticles: (event) ->
    event.preventDefault()
    localStorage.setItem("current_feed_id", event.currentTarget.id)
    Backbone.history.navigate("articles", { trigger: true })

  render: ->
    @collection.fetch()
    this
