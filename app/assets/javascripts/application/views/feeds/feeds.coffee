class App.Views.Feeds extends App.View

  events:
    'click #new_feed_submit': 'saveFeed'
    'click .unsubscribe': 'unsubscribeFeed'
    'click .get_articles': 'getArticles'

  initialize: ->
    @collection.on('add', this.addOne, this)
    @collection.on('change', this.addAll, this)

  addOne: (feedItem) ->
    feedView = new App.Views.Feed(model: feedItem)
    @$el.append(feedView.render().el)

  addAll: ->
    @collection.forEach(this.addOne, this)

  unsubscribeFeed: (event) ->
    event.preventDefault()
    feed = @collection.get(event.currentTarget.id)
    feed.destroy()

  getArticles: (event) ->
    event.preventDefault()
    localStorage.setItem("current_feed_id", event.currentTarget.id)
    Backbone.history.navigate("articles", { trigger: true })

  render: ->
    @collection.fetch()
    this
