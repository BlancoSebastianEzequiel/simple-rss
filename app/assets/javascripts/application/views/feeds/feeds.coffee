class App.Views.Feeds extends App.View

  template: JST['application/templates/feeds_list']

  events:
    'click #unsubscribe': 'unsubscribeFeed'
    'click #get_articles': 'getArticles'

  initialize: ->
    noFeedsMessage = ""
    @$el.html(@template({noFeedsMessage}))
    @collection.on('add', this.addOne, this)
    @collection.on('reset', this.addAll, this)

  addNoFeedsMessage: ->
    if (@collection.models.length == 0)
      @$el.find("#no_feed_message").text("you have no subscriptions")
    else
      @$el.find("#no_feed_message").text("")

  addOne: (feedItem) ->
    this.addNoFeedsMessage()
    feedView = new App.Views.Feed(model: feedItem)
    @$el.find("#feeds_list").append(feedView.render().el)
    @unsubscribeButton = @$el.find("#unsubscribe_#{feedItem.get("id")}")
    this.toggleEnabled(@unsubscribeButton, true)

  addAll: =>
    this.addNoFeedsMessage()
    @collection.forEach(this.addOne, this)

  unsubscribeFeed: (event) ->
    event.preventDefault()
    this.toggleEnabled(@unsubscribeButton, false)
    App.Events.trigger("feed:delete:start")
    if window.confirm("Do you really unsubscribe?")
      feed = @collection.get($(event.target).data('id'))
      feed.destroy({
        success: (model, response, options) =>
          new PNotify(text: "all articles deleted", type: 'success').get()
          App.Events.trigger("feed:delete:end")
          this.toggleEnabled(@unsubscribeButton, true)
          this.addNoFeedsMessage()
          #@collection.fetch({ reset: true })
        error: (error) ->
          new PNotify(text: JSON.stringify(JSON.parse(error.responseText).errors), type: 'error').get()
      })
    else
      App.Events.trigger("feed:delete:end")
      this.toggleEnabled(@unsubscribeButton, true)

  getArticles: (event) ->
    event.preventDefault()
    localStorage.setItem("current_feed_id", $(event.target).data('id'))
    Backbone.history.navigate("articles", { trigger: true })

  render: ->
    @collection.fetch({ reset: true })
    this
