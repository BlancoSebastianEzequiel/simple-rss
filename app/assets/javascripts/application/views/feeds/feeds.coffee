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

  addAll: ->
    @collection.forEach(this.addOne, this)

  unsubscribeFeed: (event) ->
    event.preventDefault()
    if window.confirm("Do you really unsubscribe?")
      feed = @collection.get(event.currentTarget.id)
      feed.destroy({
        success: (model, response, options) ->
          alert("Deleted")
        error: (error) ->
          alert(JSON.stringify(JSON.parse(error.responseText).errors))
      })

  getArticles: (event) ->
    event.preventDefault()
    localStorage.setItem("current_feed_id", event.currentTarget.id)
    Backbone.history.navigate("articles", { trigger: true })

  render: ->
    @collection.fetch()
    this
