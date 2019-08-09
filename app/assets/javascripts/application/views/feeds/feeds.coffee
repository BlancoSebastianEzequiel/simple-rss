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
    this.validated(@unsubscribeButton, true)

  addAll: ->
    @collection.forEach(this.addOne, this)

  unsubscribeFeed: (event) ->
    event.preventDefault()
    this.validated(@unsubscribeButton, false)
    this.validated(@collection.buttons.subscribeButton, false)
    if window.confirm("Do you really unsubscribe?")
      id = event.currentTarget.id.split("_")[1]
      feed = @collection.get(id)
      feed.destroy({
        success: (model, response, options) =>
          new PNotify(text: "all articles deleted", type: 'success').get()
          this.validated(@unsubscribeButton, true)
          this.validated(@collection.buttons.subscribeButton, true)
        error: (error) ->
          new PNotify(text: JSON.stringify(JSON.parse(error.responseText).errors), type: 'error').get()
      })
    else
      this.validated(@unsubscribeButton, true)
      this.validated(@collection.buttons.subscribeButton, true)

  getArticles: (event) ->
    event.preventDefault()
    localStorage.setItem("current_feed_id", event.currentTarget.id)
    Backbone.history.navigate("articles", { trigger: true })

  render: ->
    @collection.fetch()
    this
